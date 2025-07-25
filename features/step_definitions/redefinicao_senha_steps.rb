# encoding: utf-8
# features/step_definitions/redefinicao_senha_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Navega para a página de login.
Dado('que estou na tela de login') do
    visit new_user_session_path
  end
  
  # Cria um utilizador para o qual vamos solicitar a redefinição de senha.
  Dado('que informei meu e-mail corretamente') do
    @user = FactoryBot.create(:user, email: 'utilizador.teste@exemplo.com')
    fill_in 'E-mail', with: @user.email
    click_button 'Enviar instruções para redefinir a senha' # Ajuste o texto do botão
  end
  
  # Navega diretamente para a página de redefinição de senha.
  Dado('que estou na página de redefinição de senha') do
    # Para simular isto, precisamos de um token de redefinição válido.
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user = FactoryBot.create(:user, reset_password_token: enc, reset_password_sent_at: Time.now.utc)
    
    # Navega para a URL de edição de senha com o token.
    visit edit_user_password_path(reset_password_token: raw)
  end
  
  # Cria um token de redefinição e simula que ele já expirou.
  Dado('que recebi o link de redefinição de senha') do
    # O token é gerado no passo 'Quando'
  end
  
  Dado('que o link jå expirou ou foi usado') do
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user = FactoryBot.create(:user, reset_password_token: enc, reset_password_sent_at: 3.days.ago) # 3 dias atrás
    @token_expirado = raw
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Simula o clique no link "Esqueci minha senha".
  Quando('que cliquei em {string}') do |nome_do_link|
    click_link(nome_do_link)
  end
  
  # Simula a receção do e-mail e a visita ao link de redefinição.
  Quando('recebo o link de redefinição e acesso a página') do
    # 1. Encontra o e-mail que foi enviado.
    email = ActionMailer::Base.deliveries.last
    
    # 2. Extrai o link de redefinição do corpo do e-mail usando uma expressão regular.
    link = email.body.encoded.match(/href="([^"]+)"/)[1]
    
    # 3. Visita o link extraído.
    visit link
  end
  
  # Preenche o formulário de nova senha com uma senha válida.
  Quando('insiro uma nova senha válida') do
    fill_in 'Nova senha', with: 'novaSenha123'
    fill_in 'Confirme sua nova senha', with: 'novaSenha123'
    click_button 'Alterar minha senha'
  end
  
  # Preenche o formulário com uma senha inválida (curta).
  Quando('insiro uma nova senha com menos de 6 caracteres') do
    fill_in 'Nova senha', with: '123'
    fill_in 'Confirme sua nova senha', with: '123'
    click_button 'Alterar minha senha'
  end
  
  # Tenta aceder à página usando um token expirado.
  Quando('tento acessar a página de redefinição') do
    visit edit_user_password_path(reset_password_token: @token_expirado)
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica a mensagem de sucesso após a alteração da senha.
  Então('vejo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Tenta fazer login com a nova senha para confirmar que funcionou.
  Então('posso usara nova senha para fazer login') do
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Senha', with: 'novaSenha123'
    click_button 'Entrar'
    expect(page).to have_content('Login efetuado com sucesso.')
  end
  
  # Verifica a mensagem de erro de validação da senha.
  Então('recebo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Garante que a senha não foi alterada.
  Então('a senha não é alterada') do
    # Recarrega os dados do utilizador da base de dados e tenta fazer login com a senha antiga.
    @user.reload
    expect(@user.valid_password?('senhaAntiga123')).to be true
  end
  