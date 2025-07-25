# encoding: utf-8
# features/step_definitions/gerenciamento_departamento_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Cria um coordenador e associa-o a um departamento específico.
# Também cria dados para outro departamento para testar o isolamento.
Dado('que estou logado como coordenador do Departamento de Engenharia') do
    departamento_engenharia = FactoryBot.create(:departamento, nome: 'Engenharia')
    departamento_letras = FactoryBot.create(:departamento, nome: 'Letras')
    
    @coordenador_engenharia = FactoryBot.create(:user, :coordenador, departamento: departamento_engenharia)
    
    # Cria templates e formulários para ambos os departamentos
    template_engenharia = FactoryBot.create(:template, titulo: 'Template de Engenharia', departamento: departamento_engenharia)
    FactoryBot.create(:formulario, template: template_engenharia, coordenador: @coordenador_engenharia)
    
    template_letras = FactoryBot.create(:template, titulo: 'Template de Letras', departamento: departamento_letras)
    FactoryBot.create(:formulario, template: template_letras)
  
    # Simula o login do coordenador
    visit new_user_session_path
    fill_in 'Email', with: @coordenador_engenharia.email
    fill_in 'Senha', with: @coordenador_engenharia.password
    click_button 'Entrar'
  end
  
  # Navega para a página de listagem de formulários.
  Dado('que estou na tela de listagem de formulários') do
    visit formularios_path
  end
  
  # Prepara o cenário para o teste de acesso não autorizado.
  Dado('que estou logado como coordenador do Departamento de Letras') do
    departamento_letras = FactoryBot.create(:departamento, nome: 'Letras')
    @coordenador_letras = FactoryBot.create(:user, :coordenador, departamento: departamento_letras)
    
    visit new_user_session_path
    fill_in 'Email', with: @coordenador_letras.email
    fill_in 'Senha', with: @coordenador_letras.password
    click_button 'Entrar'
  end
  
  Dado('que recebi o link li direto para um formulário do Departamento de Medicina') do
    departamento_medicina = FactoryBot.create(:departamento, nome: 'Medicina')
    template_medicina = FactoryBot.create(:template, titulo: 'Template de Medicina', departamento: departamento_medicina)
    @formulario_medicina = FactoryBot.create(:formulario, template: template_medicina)
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Navega para a área de gestão de formulários.
  Quando('acesso a área de gerenciamento de formulários') do
    visit formularios_path
  end
  
  # Navega para a aba/página especificada.
  Quando('acesso a aba de {string} ou {string}') do |aba1, aba2|
    # Este passo pode ser adaptado. Vamos assumir que clica num link.
    # Por exemplo, clica em "Formulários".
    click_link 'Formulários'
  end
  
  # Simula a seleção de um filtro de departamento.
  Quando('seleciono o filtro {string}') do |filtro_texto|
    # Extrai o nome do departamento do texto do filtro.
    nome_departamento = filtro_texto.split(': ').last
    select nome_departamento, from: 'Departamento'
    click_button 'Filtrar'
  end
  
  # Tenta aceder diretamente à URL de um formulário de outro departamento.
  Quando('tento acessá-lo') do
    # Tenta visitar a página de edição do formulário proibido.
    visit edit_formulario_path(@formulario_medicina)
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica se apenas os dados do departamento correto estão visíveis.
  Então('vejo apenas os formulários e templates criados pelo meu departamento') do
    expect(page).to have_content('Template de Engenharia')
  end
  
  Então('não tenho acesso aos dados de outros cursos') do
    expect(page).not_to have_content('Template de Letras')
  end
  
  # Verifica se o administrador consegue ver dados de todos os departamentos.
  Então('posso visualizar, editar ou excluir formulários de todos os departamentos') do
    expect(page).to have_content('Template de Engenharia')
    expect(page).to have_content('Template de Letras')
  end
  
  # Verifica o resultado da filtragem.
  Então('vejo apenas os formulários relacionados ao Departamento de Direito') do
    expect(page).to have_content('Formulário de Direito')
    expect(page).not_to have_content('Formulário de Engenharia')
  end
  
  # Verifica a mensagem de acesso não autorizado.
  Então('recebo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  