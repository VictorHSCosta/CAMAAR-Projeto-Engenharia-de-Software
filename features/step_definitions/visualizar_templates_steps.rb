# encoding: utf-8
# features/step_definitions/visualizar_templates_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Prepara o cenário navegando para a página de listagem de templates.
Dado('que estou na lista de templates') do
    # Cria alguns templates de exemplo para a lista não estar vazia.
    template1 = FactoryBot.create(:template, titulo: 'Avaliação Docente 2025/1', publico_alvo: 'docentes')
    FactoryBot.create_list(:pergunta, 5, template: template1) # Adiciona 5 perguntas
  
    template2 = FactoryBot.create(:template, titulo: 'Avaliação Discente 2025/1', publico_alvo: 'discentes')
    FactoryBot.create_list(:pergunta, 10, template: template2) # Adiciona 10 perguntas
    
    visit templates_path
  end
  
  # Navega para a página de listagem de templates.
  Dado('que estou na listagem de templates') do
    visit templates_path
  end
  
  # Navega para a página de listagem de templates.
  Dado('que estou na tela de busca de templates') do
    visit templates_path
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Navega para a página de templates.
  Quando('acesso a aba {string}') do |_nome_da_aba|
    visit templates_path
  end
  
  # Simula o preenchimento do campo de busca e o clique no botão de pesquisar.
  Quando('digito {string} no campo de busca') do |termo_de_busca|
    fill_in 'Busca por título', with: termo_de_busca # Assumindo um campo com este label.
    click_button 'Buscar'
  end
  
  # Encontra um template específico na lista e clica no seu botão "Visualizar".
  Quando('clico em {string} ao lado de um template específico') do |nome_do_botao|
    # Encontra a linha da tabela que contém o título do template e clica no link "Visualizar".
    find('tr', text: 'Avaliação Docente 2025/1').click_link(nome_do_botao)
  end
  
  # Procura por um termo que não resultará em nenhuma correspondência.
  Quando('procuro por um nome inexistente') do
    fill_in 'Busca por título', with: 'Nome Que Não Existe 9999'
    click_button 'Buscar'
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica se a lista contém os detalhes esperados para cada template.
  Então('vejo uma lista com o nome do template, público-alvo, número de perguntas e status de uso') do
    # Verifica os detalhes do primeiro template.
    within('tr', text: 'Avaliação Docente 2025/1') do
      expect(page).to have_content('Docentes')
      expect(page).to have_content('5 perguntas')
      expect(page).to have_content('Não utilizado') # Status de uso.
    end
    
    # Verifica os detalhes do segundo template.
    within('tr', text: 'Avaliação Discente 2025/1') do
      expect(page).to have_content('Discentes')
      expect(page).to have_content('10 perguntas')
    end
  end
  
  # Verifica se o utilizador pode clicar nos botões de ação.
  Então('posso clicar em {string} e {string} para ver todas as perguntas') do |botao1, botao2|
    # Este passo é mais descritivo. A verificação real é se os botões existem.
    expect(page).to have_link(botao1)
    expect(page).to have_link(botao2)
  end
  
  # Verifica se o resultado da busca está correto.
  Então('vejo apenas os templates cujos o título contém {string}') do |termo_de_busca|
    expect(page).to have_content('Avaliação Docente 2025/1')
    expect(page).not_to have_content('Avaliação Discente 2025/1')
  end
  
  # Verifica se a página de detalhes do template mostra as perguntas.
  Então('vejo todas as perguntas cadastradas com seus respectivos tipos de resposta') do
    # Após clicar em "Visualizar", devemos estar na página `show` do template.
    expect(current_path).to match(/templates\/\d+/)
    expect(page).to have_content('Detalhes do Template')
    # Verifica se a página contém o texto de pelo menos uma das perguntas.
    expect(page).to have_content('Texto da Pergunta 1')
  end
  
  # Verifica a mensagem de "nenhum resultado encontrado".
  Então('vejo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Garante que a tabela de resultados está vazia.
  Então('a lista fica vazia até que eu redefina o filtro') do
    # Verifica que não há nenhuma linha (`<tr>`) no corpo da tabela (`<tbody>`).
    expect(page).to have_selector('tbody tr', count: 0)
  end
  