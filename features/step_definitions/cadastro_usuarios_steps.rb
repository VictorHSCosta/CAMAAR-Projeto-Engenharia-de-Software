# encoding: utf-8
# features/step_definitions/cadastro_usuarios_steps.rb

# --- Cenário 1: Cadastro manual ---
Quando('preencho nome, e-mail, tipo de usuário e departamento') do
    visit new_admin_user_path
    fill_in 'Nome Completo', with: 'Novo Professor Teste'
    fill_in 'E-mail', with: 'novo.professor@exemplo.com'
    fill_in 'Matrícula', with: '987654'
    select 'Professor', from: 'Tipo de Usuário'
    click_button 'Cadastrar Usuário'
  end
  
  Então('o usuário é salvo com sucesso') do
    expect(page).to have_content('Usuário foi criado com sucesso.')
    novo_utilizador = User.find_by(email: 'novo.professor@exemplo.com')
    expect(novo_utilizador).not_to be_nil
  end
  
  Então('recebe um e-mail com link para definição de senha') do
    email_enviado = ActionMailer::Base.deliveries.last
    expect(email_enviado).not_to be_nil
    expect(email_enviado.to).to include('novo.professor@exemplo.com')
  end
  
  # --- Cenário 2: Cadastro em lote ---
  
  Dado('que estou na tela de {string}') do |nome_da_pagina|
    visit admin_management_path
  end
  
  Dado('possuo uma planilha válida com os dados dos novos usuários') do
    @caminho_do_ficheiro = Rails.root.join('spec', 'fixtures', 'files', 'usuarios_validos.json')
  end
  
  Quando('faço upload do arquivo .json') do
    click_button 'Importar'
    attach_file('usersFile', @caminho_do_ficheiro)
    click_button 'Importar Usuários'
  end
  
  Então('todos os usuários são cadastrados automaticamente') do
    expect(page).to have_content('Importados:')
    expect(User.find_by(email: 'aluno1@exemplo.com')).not_to be_nil
    expect(User.find_by(email: 'aluno2@exemplo.com')).not_to be_nil
  end
  
  Então('cada um recebe um e-mail para definição de senha') do
    expect(ActionMailer::Base.deliveries.map(&:to).flatten).to include('aluno1@exemplo.com', 'aluno2@exemplo.com')
  end
  
  # --- Cenário 3: Cadastro com e-mail inválido ---
  
  Dado('que estou tentando cadastrar um novo usuário') do
    visit new_admin_user_path
  end
  
  Quando('informo um e-mail em formato inválido (ex: "professor@")') do
    fill_in 'E-mail', with: 'professor@'
    click_button 'Cadastrar Usuário'
  end
  
  Então('o usuário não é salvo até que o campo seja corrigido') do
    expect(User.find_by(email: 'professor@')).to be_nil
  end



  