# Sistema HubSA

Sistema de gerenciamento desenvolvido com React, TypeScript e Node.js.

## 🚀 Tecnologias

- React 18
- TypeScript
- Vite
- Node.js
- Express
- Tailwind CSS
- Shadcn UI
- React Query
- React Router DOM

## 📋 Pré-requisitos

- Node.js 18.x ou superior
- npm ou yarn
- Git
- VPS Ubuntu 20.04 LTS
- Domínio configurado

## 🔧 Instalação em Produção

### 1. Acesso à VPS

```bash
ssh root@seu-ip-da-vps
```

### 2. Download e Configuração

1. Baixe o script de instalação:
```bash
wget https://raw.githubusercontent.com/Esamwell/sistemahubsa2/main/install.sh
```

2. **IMPORTANTE**: Configure o script antes da execução:
```bash
nano install.sh
```

3. No editor nano, você precisa alterar:
   - Seu email (procure por `seu-email@exemplo.com`)
   - URL do sistema (se necessário)
   - Salve com Ctrl+X, depois Y e Enter

4. Execute a instalação:
```bash
chmod +x install.sh
sudo ./install.sh
```

## 📁 Estrutura do Projeto

```
sistemahubsa/
├── src/
│   ├── api/          # Backend Express
│   ├── components/   # Componentes React
│   ├── pages/        # Páginas da aplicação
│   ├── context/      # Contextos React
│   ├── hooks/        # Hooks personalizados
│   ├── lib/          # Utilitários e configurações
│   └── types/        # Definições de tipos TypeScript
├── public/           # Arquivos estáticos
└── data/            # Dados da aplicação
```

## 🔒 Segurança

- Autenticação JWT
- Proteção contra CSRF
- Sanitização de inputs
- Validação de dados
- Logs de segurança

## 🛠️ Manutenção

### Logs
```bash
# Logs da aplicação
pm2 logs sistemahubsa

# Logs do Nginx
tail -f /var/log/nginx/error.log
```

### Backups
Os backups são mantidos em:
```
/var/www/sistemahubsa/backups
```

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Suporte

Em caso de dúvidas ou problemas, entre em contato com o suporte técnico.
