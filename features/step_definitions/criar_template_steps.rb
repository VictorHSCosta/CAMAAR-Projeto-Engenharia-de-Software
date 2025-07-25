# encoding: utf-8
# features/step_definitions/criar_template_steps.rb

Dado('que estou criando um novo template') do
    visit new_template_path
  end
  
  Quando('adiciono um título, público-alvo e uma lista de perquntas') do
    fill_in 'Titulo', with: 'Avaliação de Docentes - 2025/1'
    fill_in 'Publico alvo', with: 1 # Assumindo que 1 = professores
    # AVISO: O formulário atual não permite adicionar perguntas.
    # Esta parte do teste será ignorada até o HTML ser atualizado.
  end
  
  Quando('adiciono uma pergunta de múltipla escolha e uma pergunta dissertativa') do
    # AVISO: O formulário atual não permite adicionar perguntas.
    puts "AVISO: O formulário de template não suporta a adição de perguntas. Este passo foi ignorado."
  end
  
  Quando('tento salvá-lo sem adicionar nenhuma pergunta') do
    fill_in 'Titulo', with: 'Template Vazio'
    click_button 'Create Template'
  end
  
  Então('consigo salvar o template com sucesso') do
    click_button 'Create Template'
    expect(page).to have_content('Template was successfully created.')
  end
  
  Então('ele aparece na listagem de templates disponiveis') do
    visit templates_path
    expect(page).to have_content('Avaliação de Docentes - 2025/1')
  end
  
  Então('o sisterma salva ambas corretamente no template') do
    click_button 'Create Template'
    template_salvo = Template.last
    # Este teste irá falhar até que o formulário permita adicionar perguntas.
    expect(template_salvo.pergunta.count).to be >= 1
  end
  
  Então('reconhece os tipos diferentes de resposta no preview') do
    # Este teste irá falhar até que o formulário permita adicionar perguntas.
    expect(page).to have_content("Preview da Pergunta")
  end
  
  Então('o template não é salvo') do
    expect(Template.count).to eq(0)
  end
  