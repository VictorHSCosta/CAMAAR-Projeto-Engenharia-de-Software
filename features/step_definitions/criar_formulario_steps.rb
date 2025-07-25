# encoding: utf-8
# features/step_definitions/criar_formulario_steps.rb
Dado('que já existe um template chamado {string}') do |nome_do_template|
    @template = FactoryBot.create(:template, titulo: nome_do_template)
  end
  
  Dado('que estou na tela de criação de formulário de avaliação') do
    visit new_formulario_path
  end
  
  Quando('seleciono esse template e clico em {string}') do |_nome_do_botao|
    visit new_formulario_path
    select @template.titulo, from: 'Template a ser enviado'
  end
  
  Quando('defino a data de envio e os destinatários') do
    fill_in 'Prazo final para respostas', with: 1.week.from_now
    select 'Todos os alunos', from: 'Visível para quem?'
    click_button 'Salvar e Publicar Formulário'
  end
  
  Quando('tento prosseguir sem selecionar um template') do
    click_button 'Salvar e Publicar Formulário'
  end
  
  Então('o sistema gera um novo formulário baseado no template') do
    expect(page).to have_content('Formulário publicado com sucesso.')
    formulario_criado = Formulario.find_by(template_id: @template.id)
    expect(formulario_criado).not_to be_nil
    @formulario = formulario_criado
  end
  
  Então('os usuários definidos recebem notificações para preenchimento') do
    expect(ActionMailer::Base.deliveries).not_to be_empty
  end
  
  Então('o formulário não é criado') do
    expect(Formulario.count).to eq(0)
  end
  
  Dado('que o template {string} já foi usado em um formulário anterior') do |nome_do_template|
    @template_reutilizado = FactoryBot.create(:template, titulo: nome_do_template)
    FactoryBot.create(:formulario, template: @template_reutilizado, coordenador: @admin)
    expect(Formulario.count).to eq(1)
  end
  
  Quando('escolho esse mesmo template para uma nova avaliação') do
    visit new_formulario_path
    select @template_reutilizado.titulo, from: 'Template a ser enviado'
    fill_in 'Prazo final para respostas', with: 2.weeks.from_now
    select 'Todos os alunos', from: 'Visível para quem?'
    click_button 'Salvar e Publicar Formulário'
  end
  
  Então('consigo criar um novo formulário com as mesmas perguntas') do
    expect(page).to have_content('Formulário publicado com sucesso.')
    expect(Formulario.count).to eq(2)
    novo_formulario = Formulario.last
    expect(novo_formulario.template).to eq(@template_reutilizado)
  end
  
  Então('alterar apenas os destinatários e datas, se desejar') do
    novo_formulario = Formulario.last
    expect(novo_formulario.data_fim).to be > 1.week.from_now
  end
  Dado('que já existe um template chamado {string}') do |nome_do_template|
    @template = FactoryBot.create(:template, titulo: nome_do_template, criado_por: @admin)
 end
  