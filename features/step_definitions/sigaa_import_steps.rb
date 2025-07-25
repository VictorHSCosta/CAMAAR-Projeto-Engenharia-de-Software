# encoding: utf-8
# features/step_definitions/sigaa_import_steps.rb

# --- Passos Comuns ---


# Simula a importação de dados através do modal na página de gestão.
Quando('clico no botão {string}') do |nome_do_botao|
  # 1. Vai para a página de gestão administrativa.
  visit admin_management_path
  
  # 2. Clica no botão "Importar" que abre o modal.
  click_button 'Importar'
  
  # 3. Dentro do modal, anexa o ficheiro e clica no botão final.
  # Assumimos que "Importar dados" refere-se à importação de utilizadores.
  @caminho_do_ficheiro = Rails.root.join('spec', 'fixtures', 'files', 'class_members.json')
  attach_file('usersFile', @caminho_do_ficheiro) # Usa o ID 'usersFile' do seu HTML.
  click_button 'Importar Usuários' # Clica no botão específico para utilizadores.
end

# --- Cenários de Teste ---

Dado('já existem usuários com os mesmos e-mails no sistema') do
  FactoryBot.create(:user, email: 'joao.silva@exemplo.com', name: 'Joao Antigo')
end

Então('os dados desses usuários são atualizados com base no JSON') do
  # CORREÇÃO: Espera até 5 segundos para que o texto 'Importados:' apareça.
  expect(page).to have_content('Importados:', wait: 5)

  user_atualizado = User.find_by(email: 'joao.silva@exemplo.com')
  expect(user_atualizado.name).to eq('Joao Novo')
end

Então('os novos usuários do JSON são adicionados') do
  novo_user = User.find_by(email: 'maria.santos@exemplo.com')
  expect(novo_user).not_to be_nil
end

Dado('que a base de dados atual já contém os mesmos usuários com os mesmos dados') do
  FactoryBot.create(:user, email: 'joao.silva@exemplo.com', name: 'Joao Novo')
  FactoryBot.create(:user, email: 'maria.santos@exemplo.com', name: 'Maria Santos')
end

Então('nenhum dado é alterado ou inserido') do
  expect(page).to have_content('Ignorados: 2', wait: 5)
  expect(User.count).to eq(2)
end

Dado('que há um erro no arquivo JSON de origem (ex: chave faltando, formatação incorreta)') do
  @caminho_do_ficheiro = Rails.root.join('spec', 'fixtures', 'files', 'dados_invalidos.json')
end

Então('vejo a mensagem {string}') do |mensagem_de_erro|
  expect(page).to have_content(mensagem_de_erro)
end

Então('nenhum dado é alterado ou inserido') do
  # CORREÇÃO: Espera até 5 segundos para que o texto 'Ignorados: 2' apareça.
  expect(page).to have_content('Ignorados: 2', wait: 5)

  expect(User.count).to eq(2)
end

Dado('que há um erro no arquivo JSON de origem (ex: chave faltando, formatação incorreta)') do
  @caminho_do_ficheiro = Rails.root.join('spec', 'fixtures', 'files', 'dados_invalidos.json')
end


Então('nenhum dado é inserido ou alterado no sistema') do
  expect(User.count).to eq(1) # Apenas o admin deve existir
end