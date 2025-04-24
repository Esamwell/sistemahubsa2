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

## 🔧 Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/sistemahubsa.git
cd sistemahubsa
```

2. Instale as dependências:
```bash
npm install
```

3. Configure as variáveis de ambiente:
```bash
cp .env.example .env
# Edite o arquivo .env com suas configurações
```

4. Inicie o servidor de desenvolvimento:
```bash
npm run dev
```

## 🏗️ Build

Para criar uma versão de produção:

```bash
npm run build
```

## 📦 Scripts Disponíveis

- `npm run dev`: Inicia o servidor de desenvolvimento
- `npm run build`: Cria a versão de produção
- `npm run preview`: Visualiza a versão de produção localmente
- `npm run lint`: Executa o linter
- `npm run api`: Inicia apenas o servidor da API

## 🌐 Deploy

Para instruções detalhadas de deploy, consulte o arquivo [DEPLOY.md](DEPLOY.md).

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

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📞 Suporte

Em caso de dúvidas ou problemas, entre em contato com o suporte técnico.
