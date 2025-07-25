# encoding: utf-8
# features/step_definitions/definicao_senha_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Cria um novo utilizador (como se um admin o tivesse criado) sem senha,
# o que deve despoletar o envio de um e-mail de "defina a sua senha".
Dado('que recebi um e-mail de boas-vindas com um link para definir minha senha') do
    # Criamos o utilizador sem senha, que é o gatilho para este fluxo.
    @novo_utilizador = FactoryBot.create(:user, password: nil, password_confirmation: nil)
  end
  
  # Confirma que o link é válido (neste caso, não fazemos nada, apenas assumimos).
  Dado('que o link está dentro do prazo de validade') do
    # A validade do link é testada no cenário de expiração.
    # Aqui, simplesmente continuamos o fluxo.
  end
  
  # Navega para a página de definição de senha.
  Dado('que estou na página de definição de senha') do
    # Para simular isto, precisamos de um token válido.
    # O fluxo real seria clicar no link do e-mail.
    # Vamos criar um token e navegar para a página manualmente.
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user = FactoryBot.create(:user, password: nil, reset_password_token: enc, reset_password_sent_at: Time.now.utc)
    
    # Usa a rota personalizada do seu routes.rb.
    visit nova_primeira_senha_path(token: raw)
  end
  
  # Simula um link que já expirou.
  Dado('que já se passaram mais de 48h desde o envio') do
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    # A data de envio do token está no passado, para além do limite de validade.
    @user_expirado = FactoryBot.create(:user, password: nil, reset_password_token: enc, reset_password_sent_at: 3.days.ago)
    @token_expirado = raw
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Extrai o link do e-mail de boas-vindas e visita-o.
  Quando('acesso o link e informo uma senha válida (mínimo 8 caracteres, pelo menos 1 número)') do
    email = ActionMailer::Base.deliveries.last
    # Procura por um link que corresponda à rota de primeira senha.
    link = email.body.encoded.match(/href="([^"]+primeira_senha[^"]+)"/)[1]
    visit link
    
    fill_in 'Nova Senha', with: 'senhaValida123'
    fill_in 'Confirmar Senha', with: 'senhaValida123'
    click_button 'Criar Senha' # Ajuste o texto do botão se for diferente.
  end
  
  # Tenta definir uma senha que não cumpre os critérios de validação.
  Quando('tento cadastrar uma senha sem número ou com menos de 6 caracteres') do
    fill_in 'Nova Senha', with: 'fraca'
    fill_in 'Confirmar Senha', with: 'fraca'
    click_button 'Criar Senha'
  end
  
  # Tenta aceder ao link com um token expirado.
  Quando('tento acessar o link') do
    visit nova_primeira_senha_path(token: @token_expirado)
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica a mensagem de sucesso e o redirecionamento.
  Então('sou redirecionado à tela de login') do
    # Após criar a senha, o utilizador deve ser levado para a página de login.
    expect(current_path).to eq(new_user_session_path)
  end
  
  # Garante que a senha não foi salva.
  Então('a senha não é salva') do
    # Recarrega os dados do utilizador da base de dados.
    @user.reload
    # Verifica que a coluna de senha encriptada continua vazia.
    expect(@user.encrypted_password).to be_blank
  end
  