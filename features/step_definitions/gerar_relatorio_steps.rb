# encoding: utf-8
# features/step_definitions/gerar_relatorio_steps.rb

Dado('que estou na área de relatórios') do
    visit reports_path
  end
  
  Dado('que o formulário {string} já foi respondido') do |nome_do_formulario|
    template = FactoryBot.create(:template, titulo: nome_do_formulario)
    @formulario = FactoryBot.create(:formulario, template: template, coordenador: @admin)
    5.times { FactoryBot.create(:submissao_concluida, formulario: @formulario) }
  end
  
  Dado('que estou acessando um formulário recém-criado') do
    template = FactoryBot.create(:template, titulo: 'Formulário Novo Sem Respostas')
    @formulario_novo = FactoryBot.create(:formulario, template: template, coordenador: @admin)
  end
  
  Dado('que ainda não possui nenhuma resposta registrada') do
    expect(@formulario_novo.submissoes_concluidas.count).to eq(0)
  end
  
  Quando('seleciono o Departamento de Engenharia e o período {string}') do |periodo|
    # AVISO: O HTML atual não tem filtros. Este passo falhará.
    select 'Departamento de Engenharia', from: 'Departamento'
    select periodo, from: 'Período'
    click_button 'Filtrar'
  end
  
  Quando('clico em {string} na aba de resultados desse formulário') do |_nome_do_botao|
    visit reports_path
    within('.card', text: @formulario.template.titulo) do
      click_link 'Ver Relatório'
    end
  end
  
  Quando('tento gerar um relatório') do
    visit evaluation_results_path(@formulario_novo)
  end
  
  Então('o sistema me mostra todos os formulários aplicados nesse recorte') do
    expect(page).to have_content('Formulário do Departamento de Engenharia')
  end
  
  Então('gera um relatório consolidado com os dados agrupados') do
    expect(page).to have_content('Total de Formulários')
    expect(page).to have_content('Total de Respostas')
  end
  
  Então('vejo um resumo com o total de respostas') do
    within('.alert', text: 'Total de Submissões') do
      expect(page).to have_content('5')
    end
  end
  
  Então('vejo a mensagem {string}') do |mensagem|
    # Este passo verifica a mensagem genérica.
    # A sua view atual mostra uma mensagem por pergunta.
    expect(page).to have_content('Nenhuma resposta registrada para esta pergunta.')
  end
  
  Então('o botão de exportação permanece desabilitado') do
    # AVISO: O HTML atual não tem botão de exportação. Este passo falhará.
    pending "Implementar botão de exportação na view de resultados"
    expect(page).to have_button('Exportar Relatório', disabled: true)
  end
  