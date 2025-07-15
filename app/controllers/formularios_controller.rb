class FormulariosController < ApplicationController
  require 'digest'
  
  before_action :set_formulario, only: %i[ show edit update destroy responder_formulario ]
  before_action :carregar_dados_do_select, only: %i[ new edit create update ]
  # Adicione aqui um before_action para garantir que apenas admins podem criar/editar
  # Exemplo: before_action :authenticate_admin!, only: %i[ new create edit update destroy ]

  # GET /formularios or /formularios.json
  def index
    @formularios = Formulario.all
  end

  # GET /formularios/1 or /formularios/1.json
  def show
    if current_user&.aluno?
      # Verifica se o formulário está ativo
      unless @formulario.ativo?
        redirect_to evaluations_path, alert: 'Este formulário não está mais disponível para resposta.'
        return
      end
     
      # Verifica se o aluno já respondeu
      if @formulario.respondido_por?(current_user)
        redirect_to evaluations_path, notice: 'Você já respondeu este formulário.'
        return
      end
     
      # Carrega as perguntas do formulário
      @perguntas = @formulario.template.pergunta.ordenadas.includes(:opcoes_pergunta)
      @resposta = {}
    end
  end

  # GET /formularios/new
  def new
    @formulario = Formulario.new
  end

  # GET /formularios/1/edit
  def edit
    # A ação de edição agora está mais limpa porque os dados são carregados pelo before_action
  end

  # POST /formularios or /formularios.json
  def create
    @formulario = Formulario.new(formulario_params)
    @formulario.coordenador_id = current_user.id
    @formulario.data_envio = Time.current

    respond_to do |format|
      if @formulario.save
        format.html { redirect_to @formulario, notice: "Formulário publicado com sucesso." }
        format.json { render :show, status: :created, location: @formulario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /formularios/1 or /formularios/1.json
  def update
    respond_to do |format|
      if @formulario.update(formulario_params)
        format.html { redirect_to @formulario, notice: "Formulário atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @formulario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @formulario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /formularios/1 or /formularios/1.json
  def destroy
    @formulario.destroy!

    respond_to do |format|
      format.html { redirect_to formularios_url, notice: "Formulário removido com sucesso." }
      format.json { head :no_content }
    end
  end

  # POST /formularios/1/responder
  def responder_formulario
    # Esta lógica continua a mesma, para os alunos
    unless @formulario.ativo?
      redirect_to evaluations_path, alert: 'Este formulário não está mais disponível para resposta.'
      return
    end
   
    if @formulario.respondido_por?(current_user)
      redirect_to evaluations_path, notice: 'Você já respondeu este formulário.'
      return
    end
   
    uuid_anonimo = gerar_uuid_anonimo(current_user)
   
    ActiveRecord::Base.transaction do
      if params[:respostas].present?
        params[:respostas].each do |pergunta_id, resposta_data|
          pergunta = @formulario.template.pergunta.find(pergunta_id)
         
          case pergunta.tipo
          when 'texto_livre'
            criar_resposta_texto(pergunta, resposta_data[:texto], uuid_anonimo)
          when 'multipla_escolha'
            if resposta_data[:opcoes].present?
              resposta_data[:opcoes].each do |opcao_id|
                criar_resposta_opcao(pergunta, opcao_id, uuid_anonimo)
              end
            end
          when 'escolha_unica', 'escala_likert'
            if resposta_data[:opcao].present?
              criar_resposta_opcao(pergunta, resposta_data[:opcao], uuid_anonimo)
            end
          end
        end
      end
    end
   
    redirect_to evaluations_path, notice: 'Formulário respondido com sucesso! Obrigado pela sua participação.'
  rescue StandardError => e
    redirect_to formulario_path(@formulario), alert: 'Erro ao salvar suas respostas. Tente novamente.'
  end

  private
    def set_formulario
      @formulario = Formulario.find(params[:id])
    end

    def formulario_params
      params.require(:formulario).permit(
        :template_id, 
        :turma_id, 
        :data_fim,
        :ativo,
        :escopo_visibilidade,
        :disciplina_id
      )
    end

    # ### CORREÇÃO AQUI ###
    # Centraliza o carregamento dos dados para os formulários de new e edit
    def carregar_dados_do_select
      @templates = Template.order(:titulo)
      @turmas = Turma.includes(:disciplina).order('disciplinas.nome')
      @disciplinas = Disciplina.order(:nome)
    end
   
    def verificar_acesso_aluno
      unless current_user&.aluno?
        redirect_to root_path, alert: 'Acesso negado.'
        return
      end
     
      unless current_user.matriculas.exists?(turma: @formulario.turma)
        redirect_to evaluations_path, alert: 'Você não tem acesso a este formulário.'
        return
      end
    end
   
    def gerar_uuid_anonimo(user)
      Digest::SHA256.hexdigest("#{user.id}-#{@formulario.id}-#{@formulario.turma.id}")
    end
   
    def criar_resposta_texto(pergunta, texto, uuid_anonimo)
      return if texto.blank?
     
      Respostum.create!(
        formulario: @formulario,
        pergunta: pergunta,
        opcao_id: 1, # Placeholder para resposta de texto
        resposta_texto: texto,
        turma: @formulario.turma,
        uuid_anonimo: uuid_anonimo
      )
    end
   
    def criar_resposta_opcao(pergunta, opcao_id, uuid_anonimo)
      return if opcao_id.blank?
     
      Respostum.create!(
        formulario: @formulario,
        pergunta: pergunta,
        opcao_id: opcao_id,
        resposta_texto: nil,
        turma: @formulario.turma,
        uuid_anonimo: uuid_anonimo
      )
    end
end
