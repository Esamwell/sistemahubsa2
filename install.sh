#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ==========================================
# CONFIGURAÇÕES - EDITE ESTA SEÇÃO
# ==========================================
DOMAIN="sistema.hubsa2.com.br"    # <-- ALTERE AQUI SUA URL
API_DOMAIN="api.hubsa2.com.br"    # <-- ALTERE AQUI SUA URL DA API
EMAIL="seu-email@exemplo.com"      # <-- ALTERE AQUI SEU EMAIL
# ==========================================

# Configurações do sistema
APP_DIR="/var/www/sistemahubsa"
REPO_URL="https://github.com/Esamwell/sistemahubsa2.git"
BRANCH="v1.0.0-beta.1"

# Função para exibir mensagens
log() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERRO] $1${NC}"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCESSO] $1${NC}"
}

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then 
    error "Este script precisa ser executado como root (sudo)."
fi

# Início da instalação
log "Iniciando instalação do Sistema HubSA..."
log "URL do sistema: $DOMAIN"
log "Email para certificado SSL: $EMAIL"

# Atualizar sistema
log "Atualizando o sistema..."
apt update && apt upgrade -y || error "Falha ao atualizar o sistema"

# Instalar dependências básicas
log "Instalando dependências básicas..."
apt install -y curl git build-essential || error "Falha ao instalar dependências básicas"

# Instalar Node.js
log "Instalando Node.js 18.x..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs || error "Falha ao instalar Node.js"

# Instalar Nginx
log "Instalando Nginx..."
apt install -y nginx || error "Falha ao instalar Nginx"

# Instalar PM2
log "Instalando PM2..."
npm install -g pm2 || error "Falha ao instalar PM2"

# Instalar Certbot
log "Instalando Certbot..."
apt install -y certbot python3-certbot-nginx || error "Falha ao instalar Certbot"

# Configurar Firewall
log "Configurando Firewall..."
apt install -y ufw
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

# Criar diretório da aplicação
log "Criando diretório da aplicação..."
if [ -d "$APP_DIR" ]; then
    log "Diretório já existe. Fazendo backup..."
    BACKUP_DIR="${APP_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
    mv $APP_DIR $BACKUP_DIR
    log "Backup criado em: $BACKUP_DIR"
fi

mkdir -p $APP_DIR
chown -R $USER:$USER $APP_DIR

# Clonar repositório
log "Clonando repositório..."
cd $APP_DIR
git clone $REPO_URL . || error "Falha ao clonar repositório"
git checkout $BRANCH || error "Falha ao mudar para a versão $BRANCH"

# Instalar dependências do projeto
log "Instalando dependências do projeto..."
npm install || error "Falha ao instalar dependências do projeto"

# Configurar variáveis de ambiente
log "Configurando variáveis de ambiente..."
cat > $APP_DIR/.env << EOF
NODE_ENV=production
PORT=3001
APP_URL=https://$DOMAIN
API_URL=https://$API_DOMAIN
VITE_API_URL=https://$API_DOMAIN/api
EOF

# Build da aplicação
log "Realizando build da aplicação..."
npm run build || error "Falha ao fazer build da aplicação"

# Configurar Nginx
log "Configurando Nginx..."
# Configuração para o frontend
cat > /etc/nginx/sites-available/sistemahubsa << EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN;
    root $APP_DIR/dist;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

# Configuração para a API
cat > /etc/nginx/sites-available/sistemahubsa-api << EOF
server {
    listen 80;
    listen [::]:80;
    server_name $API_DOMAIN;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Ativar os sites
ln -sf /etc/nginx/sites-available/sistemahubsa /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/sistemahubsa-api /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Testar e reiniciar Nginx
nginx -t || error "Configuração do Nginx inválida"
systemctl restart nginx

# Configurar SSL com Certbot
log "Configurando SSL..."
certbot --nginx -d $DOMAIN -d $API_DOMAIN --non-interactive --agree-tos --email $EMAIL || error "Falha ao configurar SSL"

# Reiniciar Nginx após configuração SSL
systemctl restart nginx

# Verificar status do Nginx
nginx -t && systemctl status nginx --no-pager

# Configurar PM2
log "Configurando PM2..."
cd $APP_DIR
pm2 start npm --name "sistemahubsa" -- start
pm2 save
pm2 startup

# Configurar renovação automática do SSL
log "Configurando renovação automática do SSL..."
(crontab -l 2>/dev/null; echo "0 3 * * * /usr/bin/certbot renew --quiet") | crontab -

# Configurar backup automático
log "Configurando backup automático..."
mkdir -p $APP_DIR/backups
cat > /etc/cron.daily/sistemahubsa-backup << EOF
#!/bin/bash
BACKUP_DIR="$APP_DIR/backups"
TIMESTAMP=\$(date +%Y%m%d_%H%M%S)
tar -czf \$BACKUP_DIR/backup_\$TIMESTAMP.tar.gz -C $APP_DIR .
find \$BACKUP_DIR -type f -mtime +7 -delete
EOF
chmod +x /etc/cron.daily/sistemahubsa-backup

# Verificação final
log "Realizando verificações finais..."
systemctl status nginx --no-pager
pm2 status
curl -I http://$DOMAIN

success "Instalação concluída com sucesso!"
echo -e "${GREEN}Sistema instalado e configurado em https://$DOMAIN${NC}"
echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Verifique se os registros DNS estão configurados corretamente"
echo "2. Acesse https://$DOMAIN para verificar se o sistema está funcionando"
echo "3. Verifique os logs com: pm2 logs sistemahubsa"

# Exibir informações importantes
echo -e "\n${YELLOW}Informações importantes:${NC}"
echo "- Diretório da aplicação: $APP_DIR"
echo "- Logs do Nginx: /var/log/nginx/"
echo "- Logs da aplicação: pm2 logs sistemahubsa"
echo "- Backups: $APP_DIR/backups"
echo "- Configuração Nginx: /etc/nginx/sites-available/sistemahubsa" 