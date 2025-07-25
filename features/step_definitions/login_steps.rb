# encoding: utf-8
# features/step_definitions/login_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Cria um utilizador genérico no banco de dados de teste.
Dado('que sou um usuário cadastrado no sistema') do
    @user = FactoryBot.create(:user, email: 'user@exemplo.com', password: 'password123')
  end
  
  # Navega para a página de login.
  Dado('que estou na tela de login') do
    visit new_user_session_path
  end
  
  # Cria um utilizador com um papel específico.
  Dado('que sou um usuário do tipo {string}') do |tipo_usuario|
    # O FactoryBot pode ser configurado com "traits" para criar diferentes tipos de utilizador.
    # Ex: FactoryBot.create(:user, :admin) ou FactoryBot.create(:user, :coordenador)
    @user = FactoryBot.create(:user, role: tipo_usuario.downcase)
  end
  
  # Prepara o cenário para testar um login com e-mail inexistente.
  Dado('que informei um e-mail que não existe no sistema') do
    @email = 'nao.existe@exemplo.com'
  end
  
  # Cria um utilizador para testar o login com senha incorreta.
  Dado('que informei um e-mail existente') do
    @user = FactoryBot.create(:user, email: 'existente@exemplo.com', password: 'passwordCorreta')
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Preenche o formulário de login com as credenciais corretas.
  Quando('informo meu e-mail e senha corretamente') do
    fill_in 'Email', with: @user.email
    fill_in 'Senha', with: @user.password
    click_button 'Entrar'
  end
  
  # Preenche o formulário de login com as credenciais do utilizador criado no passo 'Dado'.
  Quando('faço login com minhas credenciais') do
    fill_in 'Email', with: @user.email
    fill_in 'Senha', with: @user.password
    click_button 'Entrar'
  end
  
  # Tenta fazer login com um e-mail que não existe.
  Quando('tento prosseguir com o login') do
    fill_in 'Email', with: @email
    fill_in 'Senha', with: 'qualquerSenha'
    click_button 'Entrar'
  end
  
  # Tenta fazer login com a senha errada.
  Quando('digito uma senha incorreta') do
    fill_in 'Email', with: @user.email
    fill_in 'Senha', with: 'senhaErrada'
    click_button 'Entrar'
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica se o utilizador foi redirecionado para a página principal.
  Então('sou redirecionado para о painel inicial do meu perfil') do
    expect(page).to have_content('Login efetuado com sucesso.')
    expect(current_path).to eq(root_path) # Assumindo que o painel inicial é a raiz do site.
  end
  
  # Verifica se o utilizador tem acesso às suas funcionalidades.
  Então('tenho acesso às funcionalidades do meu tipo de usuário') do
    # Este passo é um pouco abstrato. Um teste real verificaria a presença de um
    # link ou botão específico daquele perfil. Ex:
    expect(page).to have_link('Minhas Disciplinas')
  end
  
  # Verifica se o painel de administração está visível.
  Então('vejo o painel administrativo com acesso a todos os departamentos') do
    expect(page).to have_link('Gerenciamento') # Link para a área de gestão do admin.
  end
  
  # Este passo é uma continuação do anterior, usando 'Mas'.
  # O Cucumber trata 'Mas' da mesma forma que 'E' ou 'Então'.
  Mas('se o login for de um {string}') do |tipo_usuario|
    # Faz logout do utilizador anterior (admin) e faz login como o novo (coordenador).
    click_link 'Sair'
    @coordenador = FactoryBot.create(:user, role: tipo_usuario.downcase)
    visit new_user_session_path
    fill_in 'Email', with: @coordenador.email
    fill_in 'Senha', with: @coordenador.password
    click_button 'Entrar'
  end
  
  # Verifica se o painel do coordenador é restrito.
  Então('o painel exibido é restrito ao seu departamento') do
    expect(page).not_to have_link('Gerenciamento') # Não deve ver o link do admin.
    expect(page).to have_content("Bem-vindo, Coordenador") # Uma mensagem específica.
  end
  
  # Verifica a mensagem de erro de login.
  Então('receboamensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Garante que o utilizador continua na página de login.
  Então('permaneço na tela de login') do
    expect(current_path).to eq(new_user_session_path)
  end
  