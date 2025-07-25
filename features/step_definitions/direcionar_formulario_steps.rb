# encoding: utf-8
# features/step_definitions/direcionar_formulario_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Cria um template especificamente para docentes, que será usado nos testes.
Dado('tenho um template de Avaliação de docentes pronto') do
    # O 'publico_alvo' é uma propriedade do modelo Template.
    @template_docentes = FactoryBot.create(:template, titulo: 'Avaliação de Docentes', publico_alvo: 'docentes')
  end
  
  # Prepara o cenário para a criação de um formulário de avaliação de disciplina.
  Dado('que estou criando um formulário de avaliação da disciplina') do
    @template_discentes = FactoryBot.create(:template, titulo: 'Avaliação da Disciplina', publico_alvo: 'discentes')
    visit new_formulario_path
  end
  
  # Navega para a página de criação de formulários.
  Dado('que estou na tela de criação formulário') do
    visit new_formulario_path
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Interpreta a seleção do público-alvo como a seleção do template correspondente.
  Quando('seleciono "Público-alvo: Docentes"') do
    visit new_formulario_path
    select @template_docentes.titulo, from: 'Template a ser enviado'
  end
  
  # Preenche as datas do formulário.
  Quando('defino as datas de abertura e encerramento') do
    fill_in 'Prazo final para respostas', with: 1.month.from_now
  end
  
  # Associa o formulário a uma disciplina específica.
  Quando('associo o formulário a turma ou departamento correto') do
    @disciplina = FactoryBot.create(:disciplina, nome: 'Engenharia de Software I')
    select 'Por disciplina', from: 'Visível para quem?'
    select @disciplina.nome, from: 'Para qual disciplina?'
  end
  
  # Seleciona o template para discentes.
  Quando('seleciono "Público-alvo: no Público-alvo: Discentes"') do
    select @template_discentes.titulo, from: 'Template a ser enviado'
  end
  
  # Vincula o formulário a uma turma específica.
  Quando('vinculoa turma {string}') do |_nome_da_turma|
    disciplina = FactoryBot.create(:disciplina, nome: 'Engenharia de Software')
    @turma = FactoryBot.create(:turma, disciplina: disciplina, semestre: '2025/1')
    
    select 'Por turma', from: 'Visível para quem?'
    select "#{@turma.disciplina.nome} - Semestre #{@turma.semestre}", from: 'Para qual turma?'
  end
  
  # Tenta salvar o formulário sem preencher os campos obrigatórios.
  Quando('tento prosseguir sem escolher se o formulário é para docentes ou discentes') do
    # Este passo é interpretado como tentar salvar sem selecionar um template.
    click_button 'Salvar e Publicar Formulário'
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica se o formulário foi criado com sucesso.
  Então('o formulário é criado com sucesso') do
    click_button 'Salvar e Publicar Formulário'
    expect(page).to have_content('Formulário publicado com sucesso.')
    @formulario = Formulario.last
    expect(@formulario).not_to be_nil
  end
  
  # Testa a lógica de visibilidade, garantindo que apenas os utilizadores corretos veem o formulário.
  Então('aparece apenas para os docentes vinculados na área de formulários recebidos') do
    docente_vinculado = FactoryBot.create(:user, :professor)
    # Assumindo que existe uma forma de associar um docente a uma disciplina.
    docente_vinculado.disciplinas << @disciplina 
    docente_nao_vinculado = FactoryBot.create(:user, :professor)
  
    # Simula o login como o docente correto e verifica se ele vê o formulário.
    click_on 'Sair' # Logout do admin
    visit new_user_session_path
    fill_in 'Email', with: docente_vinculado.email
    fill_in 'Senha', with: docente_vinculado.password
    click_button 'Entrar'
    visit evaluations_path
    expect(page).to have_content(@template_docentes.titulo)
  
    # Simula o login como o docente errado e verifica se ele NÃO vê o formulário.
    click_on 'Sair'
    visit new_user_session_path
    fill_in 'Email', with: docente_nao_vinculado.email
    fill_in 'Senha', with: docente_nao_vinculado.password
    click_button 'Entrar'
    visit evaluations_path
    expect(page).not_to have_content(@template_docentes.titulo)
  end
  
  # Verifica se o formulário foi enviado para os alunos corretos.
  Então('o sistema envia o formulário apenas para os alunos dessa turma') do
    click_button 'Salvar e Publicar Formulário'
    expect(page).to have_content('Formulário publicado com sucesso.')
    
    aluno_da_turma = FactoryBot.create(:user, :aluno)
    aluno_de_outra_turma = FactoryBot.create(:user, :aluno)
    FactoryBot.create(:matricula, user: aluno_da_turma, turma: @turma)
    
    # Usa o método do modelo para verificar a lógica de visibilidade.
    formulario = Formulario.last
    expect(formulario.can_be_seen_by?(aluno_da_turma)).to be true
    expect(formulario.can_be_seen_by?(aluno_de_outra_turma)).to be false
  end
  
  # Verifica a mensagem de validação.
  Então('vejoa mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Verifica que o formulário não foi criado.
  Então('o formulário não é criado até que essa informaçāo seja preenchida') do
    expect(Formulario.count).to eq(0)
  end
  