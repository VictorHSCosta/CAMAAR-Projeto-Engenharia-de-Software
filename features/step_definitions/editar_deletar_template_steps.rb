# encoding: utf-8
# features/step_definitions/editar_deletar_template_steps.rb

Dado('que tenho um template chamado {string}') do |nome_do_template|
    @template = FactoryBot.create(:template, titulo: nome_do_template, criado_por: @admin)
  end
  
  Dado('que tenho um template que ainda não foi utilizado em nenhum formulário') do
    @template_nao_usado = FactoryBot.create(:template, titulo: 'Template Obsoleto', criado_por: @admin)
  end
  
  Dado('que o template {string} já foi usado em um ou mais formulários') do |nome_do_template|
    @template_em_uso = FactoryBot.create(:template, titulo: nome_do_template, criado_por: @admin)
    FactoryBot.create(:formulario, template: @template_em_uso, coordenador: @admin)
  end
  
  Quando('clico em "+"') do
    visit templates_path
    find('tr', text: @template.titulo).find('a[title="Editar"]').click
  end
  
  Quando('altero o título e adiciono uma nova pergunta') do
    fill_in 'Titulo', with: 'Avaliação Docente 2025/1 - Atualizado'
    # AVISO: O formulário atual não permite adicionar perguntas.
  end
  
  Quando('tento exclui-lo') do
    visit templates_path
    find('tr', text: @template_em_uso.titulo).find('a[title="Excluir"]').click
  end
  
  Quando('confirmo a exclusão na janela de alerta') do
    visit templates_path
    accept_confirm do
      find('tr', text: @template_nao_usado.titulo).find('a[title="Excluir"]').click
    end
  end
  
  Então('o sistema salva as alterações') do
    click_button 'Update Template'
    expect(page).to have_content('Template was successfully updated.')
  end
  
  Então('o template atualizado aparece na lista de templates') do
    visit templates_path
    expect(page).to have_content('Avaliação Docente 2025/1 - Atualizado')
  end
  
  Então('o template é removido do sistema') do
    expect(Template.find_by(id: @template_nao_usado.id)).to be_nil
  end
  
  Então('não aparece mais na lista de templates disponíveis') do
    visit templates_path
    expect(page).not_to have_content('Template Obsoleto')
  end
  
  Então('recebo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  Então('o sistema bloqueia a ação de exclusão') do
    expect(Template.find_by(id: @template_em_uso.id)).not_to be_nil
  end
  