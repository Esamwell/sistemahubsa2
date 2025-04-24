import { promises as fs } from 'fs';
import { join } from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Obter o diretório atual
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Função para garantir que o diretório de dados existe
async function ensureDataDir() {
  const dataDir = join(__dirname, 'data');
  try {
    await fs.access(dataDir);
  } catch {
    await fs.mkdir(dataDir, { recursive: true });
  }
}

// Função para alterar a senha
async function changePassword(userId, currentPassword, newPassword) {
  if (!userId || !newPassword) {
    throw new Error('ID do usuário e nova senha são obrigatórios');
  }

  // Caminho para o arquivo de senhas
  const passwordFile = join(__dirname, 'data', 'passwords.json');
  
  console.log('=====================================================');
  console.log('INICIANDO PROCESSO DE ALTERAÇÃO DE SENHA');
  console.log('=====================================================');
  console.log(`ID do usuário: ${userId}`);
  
  try {
    // Garantir que o diretório existe
    await ensureDataDir();

    // Ler o arquivo de senhas atual ou criar um novo
    let passwords = {};
    try {
      const data = await fs.readFile(passwordFile, 'utf8');
      passwords = JSON.parse(data);
      console.log('Arquivo de senhas carregado com sucesso');
    } catch (error) {
      console.log('Arquivo de senhas não encontrado, criando novo arquivo');
    }

    // Se forneceu senha atual, verificar se está correta
    if (currentPassword) {
      if (passwords[userId] !== currentPassword) {
        console.log('ERRO: Senha atual incorreta');
        throw new Error('Senha atual incorreta');
      }
    }
    
    // Alterar a senha
    passwords[userId] = newPassword;
    
    // Salvar o arquivo
    await fs.writeFile(passwordFile, JSON.stringify(passwords, null, 2));
    
    console.log('=====================================================');
    console.log('SENHA ALTERADA COM SUCESSO');
    console.log('=====================================================');
    
    return true;
  } catch (error) {
    console.error('ERRO AO ALTERAR SENHA:', error);
    throw error;
  }
}

// Exportar a função para uso em outros arquivos
export { changePassword };

// Se o arquivo for executado diretamente (não importado como módulo)
if (import.meta.url === `file://${__filename}`) {
  // Exemplo de uso (apenas para testes)
  const userId = process.argv[2];
  const currentPassword = process.argv[3];
  const newPassword = process.argv[4];

  if (!userId || !newPassword) {
    console.error('Uso: node change-password.js <userId> [currentPassword] <newPassword>');
    process.exit(1);
  }

  try {
    await changePassword(userId, currentPassword, newPassword);
    console.log('Senha alterada com sucesso!');
  } catch (error) {
    console.error('Falha ao alterar senha:', error.message);
    process.exit(1);
  }
} 