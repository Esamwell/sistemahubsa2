#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Iniciando processo de deploy...${NC}"

# Diretório da aplicação
APP_DIR="/var/www/sistemahubsa"

# Verificar se está no diretório correto
if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}Diretório da aplicação não encontrado!${NC}"
    exit 1
fi

# Parar a aplicação
echo -e "${YELLOW}Parando a aplicação...${NC}"
pm2 stop sistemahubsa

# Atualizar o código
echo -e "${YELLOW}Atualizando o código...${NC}"
git pull

# Instalar dependências
echo -e "${YELLOW}Instalando dependências...${NC}"
npm install

# Build da aplicação
echo -e "${YELLOW}Realizando build da aplicação...${NC}"
npm run build

# Iniciar a aplicação
echo -e "${YELLOW}Iniciando a aplicação...${NC}"
pm2 start sistemahubsa

# Salvar configuração do PM2
echo -e "${YELLOW}Salvando configuração do PM2...${NC}"
pm2 save

echo -e "${GREEN}Deploy concluído com sucesso!${NC}" 