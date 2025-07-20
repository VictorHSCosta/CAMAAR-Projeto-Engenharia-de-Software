# frozen_string_literal: true

# Adicione um comentário de documentação para a classe TemplatesController.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[show edit update destroy]
  before_action :authorize_template, except: [:index]
  before_action :authorize_template_index, only: [:index]

  # GET /templates or /templates.json
  def index
    @templates = policy_scope(Template).includes(:criado_por)
  end

  # GET /templates/1 or /templates/1.json
  def show
    @perguntas = @template.pergunta.ordenadas.includes(:opcoes_pergunta)
  end

  # GET /templates/new
  def new
    @template = Template.new
    @template.pergunta.build # Adiciona uma pergunta inicial
  end

  # GET /templates/1/edit
  def edit
    @perguntas = @template.pergunta.ordenadas.includes(:opcoes_pergunta)
  end

  # POST /templates or /templates.json
  def create
    @template = Template.new(template_params)
    @template.disciplina_id ||= nil

    respond_to do |format|
      if @template.save
        process_perguntas if params[:perguntas]
        format.html { redirect_to @template, notice: 'Template criado com sucesso!' }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  def update
    Rails.logger.info '=== TEMPLATE UPDATE INICIADO ==='
    Rails.logger.info "Parâmetros completos: #{params.inspect}"
    Rails.logger.info "Template params: #{template_params.inspect}"

    respond_to do |format|
      if @template.update(template_params)
        Rails.logger.info 'Template atualizado com sucesso'
        process_perguntas_update if params[:perguntas]
        format.html { redirect_to @template, notice: 'Template atualizado com sucesso!' }
        format.json { render :show, status: :ok, location: @template }
      else
        Rails.logger.error "Erro ao atualizar template: #{@template.errors.full_messages}"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @template.destroy!

    respond_to do |format|
      format.html { redirect_to templates_path, status: :see_other, notice: 'Template removido com sucesso!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_template
    @template = Template.find(params[:id])
  end

  def authorize_template
    authorize(@template || Template)
  end

  def authorize_template_index
    authorize(Template)
  end

  def process_perguntas
    return unless params[:perguntas]

    Rails.logger.info '=== PROCESS PERGUNTAS INICIADO ==='
    Rails.logger.info "Parâmetros recebidos: #{params[:perguntas].inspect}"

    params[:perguntas].each do |index, pergunta_attrs|
      process_single_pergunta(index, pergunta_attrs)
    end

    Rails.logger.info '=== PROCESS PERGUNTAS FINALIZADO ==='
  end

  def process_single_pergunta(index, pergunta_attrs)
    Rails.logger.info "Processando pergunta #{index}: #{pergunta_attrs.inspect}"

    return if pergunta_attrs[:texto].blank?

    pergunta = create_pergunta(pergunta_attrs)
    Rails.logger.info "Pergunta criada: ID=#{pergunta.id}, Texto=#{pergunta.texto}"

    create_opcoes_for_pergunta(pergunta, pergunta_attrs)
  end

  def create_pergunta(pergunta_attrs)
    obrigatoria_values = %w[1 on]
    @template.pergunta.create!(
      texto: pergunta_attrs[:texto],
      tipo: pergunta_attrs[:tipo],
      obrigatoria: obrigatoria_values.include?(pergunta_attrs[:obrigatoria])
    )
  end

  def create_opcoes_for_pergunta(pergunta, pergunta_attrs)
    return unless pergunta_attrs[:opcoes] && pergunta.multipla_escolha_ou_verdadeiro_falso?

    pergunta_attrs[:opcoes].each_value do |opcao_texto|
      next if opcao_texto.blank?

      opcao = pergunta.opcoes_pergunta.create!(texto: opcao_texto)
      Rails.logger.info "Opção criada: ID=#{opcao.id}, Texto=#{opcao.texto}"
    end
  end

  def process_perguntas_update
    return unless params[:perguntas]

    # Coletar IDs das perguntas que foram enviadas
    pergunta_ids_enviadas = []

    params[:perguntas].each_value do |pergunta_attrs|
      next if pergunta_attrs[:texto].blank?

      pergunta = process_pergunta_update(pergunta_attrs)
      pergunta_ids_enviadas << pergunta.id

      create_opcoes_for_pergunta(pergunta, pergunta_attrs)
    end

    # Remover perguntas que não foram enviadas (foram deletadas no frontend)
    @template.pergunta.where.not(id: pergunta_ids_enviadas).destroy_all
  end

  def process_pergunta_update(pergunta_attrs)
    if pergunta_attrs[:id].present?
      update_existing_pergunta(pergunta_attrs)
    else
      create_new_pergunta(pergunta_attrs)
    end
  end

  def update_existing_pergunta(pergunta_attrs)
    pergunta = @template.pergunta.find(pergunta_attrs[:id])
    obrigatoria_values = %w[1 on]
    pergunta.update!(
      texto: pergunta_attrs[:texto],
      tipo: pergunta_attrs[:tipo],
      obrigatoria: obrigatoria_values.include?(pergunta_attrs[:obrigatoria])
    )

    # Remover opções existentes e recriar
    pergunta.opcoes_pergunta.destroy_all
    pergunta
  end

  def create_new_pergunta(pergunta_attrs)
    obrigatoria_values = %w[1 on]
    @template.pergunta.create!(
      texto: pergunta_attrs[:texto],
      tipo: pergunta_attrs[:tipo],
      obrigatoria: obrigatoria_values.include?(pergunta_attrs[:obrigatoria])
    )
  end

  # Only allow a list of trusted parameters through.
  def template_params
    params.require(:template).permit(:titulo, :publico_alvo, :criado_por_id, :disciplina_id)
  end
end
