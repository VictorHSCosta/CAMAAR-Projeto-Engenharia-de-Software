# encoding: utf-8
# features/step_definitions/visualizacao_formularios_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Faz o login de um utilizador com o papel de "aluno" (discente).
Dado('que estou logado como discente') do
    @discente = FactoryBot.create(:user, :aluno)
    visit new_user_session_path
    fill_in 'Email', with: @discente.email
    fill_in 'Senha', with: @discente.password
    click_button 'Entrar'
  end
  
  # Garante que não existem formulários visíveis para o utilizador atual.
  Dado('que nenhum formulário está atribuído a mim') do
    # Não faz nada, a base de dados de teste está limpa por defeito.
    # Este passo serve para garantir a legibilidade do cenário.
  end
  
  # Faz o login de um utilizador com o papel de "professor" (docente).
  Dado('que estou logado como docente') do
    @docente = FactoryBot.create(:user, :professor)
    visit new_user_session_path
    fill_in 'Email', with: @docente.email
    fill_in 'Senha', with: @docente.password
    click_button 'Entrar'
  end
  
  # Cria um formulário e simula que o utilizador atual já o respondeu.
  Dado('que já respondi ao formulário {string}') do |nome_do_formulario|
    # Faz login como discente primeiro
    steps %{ Dado que estou logado como discente }
    
    template = FactoryBot.create(:template, titulo: nome_do_formulario)
    @formulario_respondido = FactoryBot.create(:formulario, template: template, data_fim: 1.week.from_now, ativo: true)
    
    # Cria o registo de que o formulário foi concluído pelo discente.
    FactoryBot.create(:submissao_concluida, formulario: @formulario_respondido, user: @discente)
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Navega para a página onde os formulários para responder são listados.
  Quando('acesso a aba {string}') do |_nome_da_aba|
    # A sua aplicação usa a rota /evaluations para esta funcionalidade.
    visit evaluations_path
  end
  
  # Navega para a lista de formulários do utilizador.
  Quando('acesso minha lista de formulários') do
    visit evaluations_path
  end
  
  Quando('acesso a lista de formulários') do
    visit evaluations_path
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica a mensagem de "estado vazio".
  Então('vejo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Verifica se uma lista de formulários é exibida.
  Então('vejo uma lista com os formulários direcionados a mim') do
    # Cria um formulário que o discente DEVE ver.
    template = FactoryBot.create(:template, titulo: 'Formulário Visível')
    FactoryBot.create(:formulario, template: template, data_fim: 1.week.from_now, ativo: true)
    
    # Recarrega a página para ver as alterações.
    visit evaluations_path
    expect(page).to have_content('Formulário Visível')
  end
  
  # Verifica os detalhes de um item na lista.
  Então('cada item mostra título, prazo final e status (aberto ou encerrado)') do
    # Este passo é mais descritivo. A verificação real pode ser feita
    # procurando por elementos específicos dentro do card do formulário.
    within('.card', text: 'Formulário Visível') do
      expect(page).to have_content('Prazo:')
      expect(page).to have_content('Aberto') # Ou um status similar.
    end
  end
  
  # Verifica se o botão "Responder" está presente e funcional.
  Então('consigo clicar em {string} se o formulário ainda estiver ativo') do |nome_do_botao|
    expect(page).to have_link(nome_do_botao)
    click_link nome_do_botao
    # Verifica se foi redirecionado para a página de resposta.
    expect(page).to have_content('Responda às perguntas abaixo') # Ajuste o texto esperado.
  end
  
  # Verifica se apenas formulários para docentes são exibidos.
  Então('vejo apenas formulários configurados para docentes') do
    # Cria um formulário para docentes e um para discentes.
    template_docente = FactoryBot.create(:template, publico_alvo: 'docentes', titulo: 'Formulário para Docentes')
    FactoryBot.create(:formulario, template: template_docente, ativo: true)
    
    template_discente = FactoryBot.create(:template, publico_alvo: 'discentes', titulo: 'Formulário para Discentes')
    FactoryBot.create(:formulario, template: template_discente, ativo: true)
    
    visit evaluations_path
    expect(page).to have_content('Formulário para Docentes')
  end
  
  Então('não vejo formulários direcionadosa discentes') do
    expect(page).not_to have_content('Formulário para Discentes')
  end
  
  # Verifica se o formulário já respondido tem o status correto.
  Então('esse formulário aparece com o status {string}') do |status|
    within('.card', text: @formulario_respondido.template.titulo) do
      expect(page).to have_content(status)
    end
  end
  
  # Verifica que a opção de responder não está mais disponível.
  Então('a opção {string} está desabilitada ou oculta') do |nome_do_botao|
    within('.card', text: @formulario_respondido.template.titulo) do
      expect(page).not_to have_link(nome_do_botao)
    end
  end
  