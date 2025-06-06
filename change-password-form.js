// Arquivo HTML para alteração de senha
const html = `
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alterar Senha</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        button {
            background-color: #FF6B1A;
            color: white;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
        }
        .message {
            padding: 10px;
            margin-top: 15px;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <h1>Alterar Senha</h1>
    <p>Atualize sua senha de acesso ao sistema.</p>
    
    <form id="passwordForm">
        <div class="form-group">
            <label for="userId">ID do Usuário:</label>
            <input type="text" id="userId" name="userId" value="admin-1" readonly>
        </div>
        
        <div class="form-group">
            <label for="currentPassword">Senha Atual:</label>
            <input type="password" id="currentPassword" name="currentPassword" required>
        </div>
        
        <div class="form-group">
            <label for="newPassword">Nova Senha:</label>
            <input type="password" id="newPassword" name="newPassword" required>
        </div>
        
        <div class="form-group">
            <label for="confirmPassword">Confirmar Nova Senha:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        
        <button type="submit">Alterar Senha</button>
    </form>
    
    <div id="message" class="message" style="display: none;"></div>
    
    <script>
        document.getElementById('passwordForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const userId = document.getElementById('userId').value;
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const messageDiv = document.getElementById('message');
            
            // Limpar mensagem anterior
            messageDiv.style.display = 'none';
            messageDiv.className = 'message';
            
            // Validações
            if (!currentPassword || !newPassword || !confirmPassword) {
                showMessage('Todos os campos são obrigatórios.', 'error');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showMessage('A nova senha e a confirmação não correspondem.', 'error');
                return;
            }
            
            try {
                // Enviar requisição para o servidor
                const response = await fetch('http://localhost:3001/api/update-password', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Cache-Control': 'no-cache'
                    },
                    body: JSON.stringify({
                        userId,
                        currentPassword,
                        newPassword
                    })
                });
                
                const data = await response.json();
                
                if (response.ok && data.success) {
                    showMessage('Senha alterada com sucesso!', 'success');
                    // Limpar campos
                    document.getElementById('currentPassword').value = '';
                    document.getElementById('newPassword').value = '';
                    document.getElementById('confirmPassword').value = '';
                } else {
                    showMessage(data.message || 'Erro ao alterar senha.', 'error');
                }
            } catch (error) {
                console.error('Erro:', error);
                showMessage('Erro ao comunicar com o servidor.', 'error');
            }
        });
        
        function showMessage(text, type) {
            const messageDiv = document.getElementById('message');
            messageDiv.textContent = text;
            messageDiv.className = 'message ' + type;
            messageDiv.style.display = 'block';
        }
    </script>
</body>
</html>
`;

// Escrever o arquivo HTML
import { writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

try {
  writeFileSync(join(__dirname, 'change-password.html'), html);
  console.log('Arquivo HTML gerado com sucesso!');
} catch (error) {
  console.error('Erro ao gerar arquivo HTML:', error);
} 