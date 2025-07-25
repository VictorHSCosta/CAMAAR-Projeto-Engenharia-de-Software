# encoding: utf-8
# features/step_definitions/visualizar_resultados_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Cria um formulário que ainda está ativo e dentro do prazo.
Dado('que o formulário {string} ainda está em periodo de resposta') do |nome_do_formulario|
    template = FactoryBot.create(:template, titulo: nome_do_formulario)
    @formulario_ativo = FactoryBot.create(:formulario, template: template, data_fim: 1.week.from_now, ativo: true)
  end
  
  # Simula que já existem algumas respostas para o formulário.
  Dado('que já existem algumas submissões') do
    3.times { FactoryBot.create(:submissao_concluida, formulario: @formulario_ativo) }
  end
  
  # Cria um formulário com respostas para o cenário de sucesso.
  Dado('que há um formulário publicado com respostas coletadas') do
    template = FactoryBot.create(:template, titulo: 'Formulário com Respostas')
    @formulario_com_respostas = FactoryBot.create(:formulario, template: template, ativo: true)
    5.times { FactoryBot.create(:submissao_concluida, formulario: @formulario_com_respostas) }
  end
  
  # Prepara o cenário de teste de permissão.
  Dado('que estou logado como coordenador do curso de Engenharia') do
    departamento_engenharia = FactoryBot.create(:departamento, nome: 'Engenharia')
    @coordenador_engenharia = FactoryBot.create(:user, :coordenador, departamento: departamento_engenharia)
    
    visit new_user_session_path
    fill_in 'Email', with: @coordenador_engenharia.email
    fill_in 'Senha', with: @coordenador_engenharia.password
    click_button 'Entrar'
  end
  
  Dado('que o formulário pertence aо curso de Direito') do
    departamento_direito = FactoryBot.create(:departamento, nome: 'Direito')
    template_direito = FactoryBot.create(:template, titulo: 'Formulário de Direito', departamento: departamento_direito)
    @formulario_direito = FactoryBot.create(:formulario, template: template_direito)
  end
  
  # --- Passos de Ação (Quando) ---
  

  
  # Navega para a página de resultados.
  Quando('acesso a aba {string}') do |_nome_da_aba|
    visit reports_path
  end
  
  # Tenta aceder à página de resultados de um formulário de outro departamento.
  Quando('tento acessar a visualização dos resultados') do
    visit evaluation_results_path(@formulario_direito)
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica se o aviso de "formulário ativo" é exibido.
  Então('vejo as respostas parciais com um aviso de que o formulário ainda está ativo') do
    expect(page).to have_content('Aviso: Este formulário ainda está a receber respostas.')
    # Verifica se os resultados parciais são mostrados.
    expect(page).to have_content('Total de Submissões: 3')
  end
  
  # Verifica se a lista de respostas é exibida.
  Então('devo ver a listagem das respostas vinculadas ao formulário') do
    visit evaluation_results_path(@formulario_com_respostas)
    expect(page).to have_content('Total de Submissões: 5')
  end
  
  # Verifica se existem opções de visualização.
  Então('consigo visualizar os dados por pergunta ou por respondente') do
    # Verifica a presença de elementos que indicam estas visualizações.
    expect(page).to have_content('Análise Detalhada por Pergunta')
    # A visualização por respondente pode ser um link ou um botão.
    expect(page).to have_link('Ver Respostas Individuais')
  end
  
  # Verifica a mensagem de erro de acesso negado.
  Então('recebo uma mensagem de erro: {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  