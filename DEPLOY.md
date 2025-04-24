# Instruções de Deploy - Sistema HubSA

Este documento contém as instruções para deploy do sistema em uma VPS Ubuntu 20.04 LTS.

## Pré-requisitos

- VPS Ubuntu 20.04 LTS
- Acesso root ou usuário com privilégios sudo
- Domínio configurado e apontando para o IP da VPS
- Git instalado na máquina local

## Passo a Passo

### 1. Preparação da VPS

1. Acesse sua VPS via SSH:
```bash
ssh usuario@seu-ip
```

2. Copie os scripts de instalação e deploy:
```bash
scp install.sh deploy.sh usuario@seu-ip:~/
```

3. Torne os scripts executáveis:
```bash
chmod +x install.sh deploy.sh
```

4. Execute o script de instalação:
```bash
./install.sh
```

### 2. Configuração do Domínio

1. Acesse o painel de controle do seu provedor de DNS
2. Configure os registros A apontando para o IP da VPS:
   - @ -> IP da VPS
   - www -> IP da VPS

### 3. Configuração SSL

1. Após o DNS propagar (pode levar até 24h), execute:
```bash
sudo certbot --nginx -d seu-dominio.com
```

2. Siga as instruções do Certbot para configurar o SSL

### 4. Deploy da Aplicação

1. Clone o repositório:
```bash
cd /var/www/sistemahubsa
git clone seu-repositorio .
```

2. Configure as variáveis de ambiente:
```bash
cp .env.example .env
nano .env
```

3. Execute o deploy:
```bash
./deploy.sh
```

## Manutenção

### Atualizações

Para atualizar o sistema, execute:
```bash
./deploy.sh
```

### Logs

- Logs da aplicação:
```bash
pm2 logs sistemahubsa
```

- Logs do Nginx:
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### Backup

O sistema mantém backups automáticos na pasta `/var/www/sistemahubsa/backups`

### Reiniciar Serviços

- Reiniciar aplicação:
```bash
pm2 restart sistemahubsa
```

- Reiniciar Nginx:
```bash
sudo systemctl restart nginx
```

## Troubleshooting

### Problemas Comuns

1. **Aplicação não inicia**
   - Verifique os logs: `pm2 logs sistemahubsa`
   - Verifique as permissões: `ls -la /var/www/sistemahubsa`

2. **Erro 502 Bad Gateway**
   - Verifique se a aplicação está rodando: `pm2 status`
   - Verifique os logs do Nginx: `sudo tail -f /var/log/nginx/error.log`

3. **SSL não funciona**
   - Verifique a configuração do Certbot: `sudo certbot certificates`
   - Renove o certificado: `sudo certbot renew --dry-run`

### Contato

Em caso de problemas, entre em contato com o suporte técnico. 