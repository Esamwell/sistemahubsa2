#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Iniciando instalação do ambiente...${NC}"

# Atualizar o sistema
echo -e "${YELLOW}Atualizando o sistema...${NC}"
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo -e "${YELLOW}Instalando dependências básicas...${NC}"
sudo apt install -y curl git build-essential

# Instalar Node.js 18.x (LTS)
echo -e "${YELLOW}Instalando Node.js 18.x...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar Nginx
echo -e "${YELLOW}Instalando Nginx...${NC}"
sudo apt install -y nginx

# Instalar PM2 globalmente
echo -e "${YELLOW}Instalando PM2...${NC}"
sudo npm install -g pm2

# Instalar Certbot para SSL
echo -e "${YELLOW}Instalando Certbot...${NC}"
sudo apt install -y certbot python3-certbot-nginx

# Configurar firewall
echo -e "${YELLOW}Configurando firewall...${NC}"
sudo apt install -y ufw
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# Criar diretório da aplicação
echo -e "${YELLOW}Criando diretório da aplicação...${NC}"
sudo mkdir -p /var/www/sistemahubsa
sudo chown -R $USER:$USER /var/www/sistemahubsa

# Configurar Nginx
echo -e "${YELLOW}Configurando Nginx...${NC}"
sudo tee /etc/nginx/sites-available/sistemahubsa << EOF
server {
    listen 80;
    server_name _;
    root /var/www/sistemahubsa/dist;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /api {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Ativar configuração do Nginx
sudo ln -sf /etc/nginx/sites-available/sistemahubsa /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

# Criar arquivo de ambiente
echo -e "${YELLOW}Criando arquivo de ambiente...${NC}"
cat > /var/www/sistemahubsa/.env << EOF
NODE_ENV=production
PORT=3001
EOF

# Instruções finais
echo -e "${GREEN}Instalação concluída!${NC}"
echo -e "${YELLOW}Próximos passos:${NC}"
echo -e "1. Configure seu domínio nos registros DNS apontando para o IP da VPS"
echo -e "2. Execute: sudo certbot --nginx -d seu-dominio.com"
echo -e "3. Clone seu repositório em /var/www/sistemahubsa"
echo -e "4. Execute: npm install"
echo -e "5. Execute: npm run build"
echo -e "6. Execute: pm2 start npm --name 'sistemahubsa' -- start"
echo -e "7. Execute: pm2 save"
echo -e "8. Execute: pm2 startup" 