# encoding: utf-8
# features/step_definitions/importar_sigaa_steps.rb

# --- Passos de Pré-condição (Dado) ---

# Prepara o cenário com um ficheiro JSON de teste válido.
Dado('que tenho um arquivo JSON simulado com os dados da turma {string}') do |_nome_da_turma|
    @caminho_do_ficheiro = Rails.root.join('spec', 'fixtures', 'files', 'sigaa_turma_A.json')
  end
  
  # Prepara o cenário com um ficheiro JSON que contém utilizadores que já existem.
  Dado('que o JSON contém alguns usuários já existentes no sistema') do
    # Cria um utilizador que já existe para testar a lógica de "ignorar duplicados".
    FactoryBot.create(:user, email: 'aluno.existente@exemplo.com')
    @caminho_do_ficheiro = Rails.root.join('spec', 'fixtures', 'files', 'sigaa_com_duplicados.json')
  end
  
  # Prepara o cenário para o teste de erro.
  Dado('que estou tentando importar um arquivo JSON') do
    # Este passo serve apenas para dar contexto ao cenário.
  end
  
  # Prepara o cenário com um ficheiro JSON mal formatado.
  Dado('que o arquivo está mal formatado (ex: falta de colchetes ou campos obrigatórios)') do
    @caminho_do_ficheiro = Rails.root.join('spec', 'fixtures', 'files', 'sigaa_invalido.json')
  end
  
  # --- Passos de Ação (Quando) ---
  
  # Simula o fluxo completo de importação através do modal.
  Quando('clico em {string} e seleciono o arquivo') do |_nome_do_botao|
    visit admin_management_path
    click_button 'Importar' # Abre o modal
    
    # O seu HTML tem dois formulários de upload. Este passo assume que estamos a importar disciplinas.
    attach_file('disciplinesFile', @caminho_do_ficheiro)
    click_button 'Importar Disciplinas'
  end
  
  # Simula a importação, que pode ser a mesma ação do passo anterior.
  Quando('executo a importação') do
    visit admin_management_path
    click_button 'Importar'
    attach_file('disciplinesFile', @caminho_do_ficheiro)
    click_button 'Importar Disciplinas'
  end
  
  # Simula a tentativa de importação de um ficheiro inválido.
  Quando('tento realizar a importação') do
    visit admin_management_path
    click_button 'Importar'
    attach_file('disciplinesFile', @caminho_do_ficheiro)
    click_button 'Importar Disciplinas'
  end
  
  # --- Passos de Verificação (Então) ---
  
  # Verifica se os utilizadores do ficheiro JSON foram criados na base de dados.
  Então('o sistema importa os usuários (discentes e docentes) com sucesso') do
    expect(page).to have_content('Importados com sucesso') # Ajuste a mensagem de sucesso
    expect(User.find_by(email: 'docente.sigaa@exemplo.com')).not_to be_nil
    expect(User.find_by(email: 'discente.sigaa@exemplo.com')).not_to be_nil
  end
  
  # Verifica se os utilizadores duplicados foram ignorados.
  Então('o sistema ignora os duplicados com base no e-mail') do
    # A mensagem de sucesso deve indicar que alguns foram ignorados.
    expect(page).to have_content('Ignorados: 1')
  end
  
  # Verifica se os novos utilizadores foram adicionados.
  Então('adiciona apenas os novos usuários') do
    expect(User.find_by(email: 'aluno.novo.sigaa@exemplo.com')).not_to be_nil
  end
  
  # Verifica a mensagem de erro.
  Então('vejo a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
  end
  
  # Garante que nada foi salvo na base de dados em caso de erro.
  Então('nenhum dado é salvo no sistema') do
    # Assumindo que o teste começou com 1 utilizador (o admin).
    expect(User.count).to eq(1)
  end
  