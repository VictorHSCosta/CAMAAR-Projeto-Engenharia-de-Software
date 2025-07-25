# encoding: utf-8
# features/step_definitions/responder_formulario_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Cria um formulário que está ativo e dentro do prazo para ser respondido.
# Também cria e faz o login de um utilizador (aluno) que pode responder.
Dado('que recebi um formulário de avaliação dentro do prazo') do
    @aluno = FactoryBot.create(:user, :aluno)
    template = FactoryBot.create(:template, titulo: 'Avaliação de Disciplina')
    # Cria uma pergunta obrigatória no template.
    @pergunta_obrigatoria = FactoryBot.create(:pergunta, template: template, texto: 'Esta pergunta é obrigatória', obrigatoria: true)
    
    # Cria o formulário com prazo para daqui a uma semana.
    @formulario = FactoryBot.create(:formulario, template: template, data_fim: 1.week.from_now, ativo: true)
    
    # Simula o login do aluno.
    visit new_user_session_path
    fill_in 'Email', with: @aluno.email
    fill_in 'Senha', with: @aluno.password
    click_button 'Entrar'
  end
  
  # Cria um formulário que é explicitamente anónimo.
  Dado('que recebi um formulário configurado como {string}') do |tipo|
    # A lógica de "anónimo" pode estar no template ou no formulário.
    # Vamos assumir que está no template.
    template = FactoryBot.create(:template, titulo: 'Pesquisa Anónima', anonimo: true)
    @formulario = FactoryBot.create(:formulario, template: template, data_fim: 1.week.from_now, ativo: true)
    
    @aluno = FactoryBot.create(:user, :aluno)
    visit new_user_session_path
    fill_in 'Email', with: @aluno.email
    fill_in 'Senha', with: @aluno.password
    click_button 'Entrar'
  end
  
  # Navega para a página de resposta de um formulário.
  Dado('que estou na tela de resposta de um formulário') do
    # Reutiliza a configuração do primeiro passo.
    steps %{
      Dado que recebi um formulário de avaliação dentro do prazo
    }
    visit evaluation_path(@formulario)
  end
  
  # Cria um formulário cujo prazo de resposta já expirou.
  Dado('que o prazo de resposta do formulário terminou') do
    @aluno = FactoryBot.create(:user, :aluno)
    template = FactoryBot.create(:template, titulo: 'Formulário Expirado')
    # A data de fim está no passado.
    @formulario_expirado = FactoryBot.create(:formulario, template: template, data_fim: 1.day.ago, ativo: true)
    
    visit new_user_session_path
    fill_in 'Email', with: @aluno.email
    fill_in 'Senha', with: @aluno.password
    click_button 'Entrar'
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Navega para a página de avaliações e clica no link do formulário.
  Quando('acesso o link na minha área de formulários') do
    visit evaluations_path
    click_link @formulario.template.titulo
  end
  
  # Preenche a pergunta obrigatória do formulário.
  Quando('preencho todas as perguntas obrigatórias') do
    fill_in "respostas[#{@pergunta_obrigatoria.id}]", with: 'Esta é a minha resposta.'
  end
  
  # Simplesmente submete as respostas (pode ser combinado com o passo anterior).
  Quando('envio minhas respostas') do
    click_button 'Enviar Respostas' # Ajuste o texto do botão se for diferente.
  end
  
  # Deixa a pergunta obrigatória em branco.
  Quando('deixo uma ou mais perguntas obrigatórias em branco') do
    # Não faz nada, simplesmente deixa o campo vazio.
  end
  
  
  # Tenta aceder ao formulário expirado.
  Quando('tento acessá-lo pela minha área de formulários') do
    visit evaluations_path
    # O link para o formulário expirado não deve estar visível.
    # Se estivesse, o clique falharia ou levaria a uma página de erro.
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica a mensagem de sucesso.
  Então('vejo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Verifica se o formulário não pode mais ser respondido.
  Então('não posso mais editar ou reenviar as respostas') do
    visit evaluations_path
    # O formulário deve agora aparecer na lista de "respondidos".
    within('.formularios-respondidos') do
      expect(page).to have_content(@formulario.template.titulo)
    end
    # O link para responder não deve mais existir.
    expect(page).not_to have_link(@formulario.template.titulo, href: evaluation_path(@formulario))
  end
  
  # Verifica se a resposta foi salva sem a identificação do utilizador.
  Então('o sistema registra as respostas sem associar meu nome ou ID de usuário') do
    resposta_salva = Respostum.last
    # A submissão concluída deve ter um user_id nulo para ser anónima.
    submissao = SubmissaoConcluida.find_by(uuid_anonimo: resposta_salva.uuid_anonimo)
    expect(submissao.user_id).to be_nil
  end
  
  # Verifica se o formulário não foi submetido.
  Então('o formulário não é submetido até que todas as perguntas sejam preenchidas') do
    # Garante que nenhuma submissão foi criada na base de dados.
    expect(SubmissaoConcluida.count).to eq(0)
  end
  