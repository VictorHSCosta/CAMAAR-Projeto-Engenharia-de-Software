# encoding: utf-8
Dado('que estou logado como administrador') do
  @admin = FactoryBot.create(:user, :admin)
  visit new_user_session_path
  fill_in 'Email', with: @admin.email
  fill_in 'Senha', with: @admin.password
  click_button 'Entrar'
  expect(page).to have_content('Signed in successfully.')
end

Quando('clico em {string}') do |nome_do_link_ou_botao|
  click_on(nome_do_link_ou_botao)
end