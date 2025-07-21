# frozen_string_literal: true

# Controller responsável por gerenciar avaliações para usuários
class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @formularios = if current_user.admin?
                     # Administradores veem todos os formulários ativos (sem filtro de período)
                     Formulario.where(ativo: true)
                   elsif current_user.coordenador?
                     # Coordenadores veem formulários que eles criaram ou que são da sua área
                     Formulario.where(ativo: true, coordenador: current_user)
                   else
                     # Usuários normais veem apenas formulários que podem responder
                     Formulario.ativos.no_periodo.select do |formulario|
                       formulario.can_be_seen_by?(current_user)
                     end
                   end

    # Separar em formulários disponíveis e já respondidos
    if current_user.admin? || current_user.coordenador?
      # Para admins e coordenadores, todos são "disponíveis" (para visualização/gestão)
      @formularios_disponiveis = @formularios
      @formularios_respondidos = []
    else
      # Para outros usuários, separar entre disponíveis e respondidos
      @formularios_disponiveis = @formularios.reject { |f| f.already_answered_by?(current_user) }
      @formularios_respondidos = @formularios.select { |f| f.already_answered_by?(current_user) }
    end
  end

  def show
    @formulario = Formulario.find(params[:id])

    # Verificar se o usuário pode ver este formulário
    unless @formulario.can_be_seen_by?(current_user)
      redirect_to evaluations_path, alert: 'Você não tem permissão para acessar este formulário.'
      return
    end

    # Verificar se já foi respondido
    if @formulario.already_answered_by?(current_user)
      redirect_to evaluations_path, notice: 'Você já respondeu este formulário.'
      return
    end

    @template = @formulario.template
    @perguntas = @template.pergunta.order(:id)

    # Se for POST, processar as respostas
    return unless request.post?

    process_respostas
  end

  # Mostrar resultados estatísticos do formulário (para administradores e coordenadores)
  def results
    @formulario = Formulario.find(params[:id])

    # Verificar se o usuário tem permissão para ver resultados
    unless current_user&.admin? || (current_user&.coordenador? && @formulario.coordenador == current_user)
      redirect_to evaluations_path, alert: 'Acesso negado. Você não tem permissão para ver estes resultados.'
      return
    end

    @template = @formulario.template

    # Buscar todas as respostas para este formulário
    @respostas = Respostum.where(formulario: @formulario)

    # Calcular estatísticas para cada pergunta
    @estatisticas = {}
    @template.pergunta.each do |pergunta|
      respostas_pergunta = @respostas.where(pergunta: pergunta)

      case pergunta.tipo
      when 'subjetiva'
        @estatisticas[pergunta.id] = {
          tipo: 'subjetiva',
          total_respostas: respostas_pergunta.count,
          respostas_texto: respostas_pergunta.where.not(resposta_texto: [nil, '']).pluck(:resposta_texto)
        }
      when 'multipla_escolha'
        opcoes_stats = {}
        pergunta.opcoes_pergunta.each do |opcao|
          opcoes_stats[opcao.id] = {
            texto: opcao.texto,
            count: respostas_pergunta.where(opcao: opcao).count
          }
        end
        @estatisticas[pergunta.id] = {
          tipo: pergunta.tipo,
          total_respostas: respostas_pergunta.count,
          opcoes: opcoes_stats
        }
      when 'verdadeiro_falso'
        # Para verdadeiro/falso, usar resposta_texto
        opcoes_stats = {}

        # Contar respostas "true" (verdadeiro)
        verdadeiro_count = respostas_pergunta.where(resposta_texto: %w[true True TRUE Verdadeiro]).count
        opcoes_stats['verdadeiro'] = {
          texto: 'Verdadeiro',
          count: verdadeiro_count
        }

        # Contar respostas "false" (falso)
        falso_count = respostas_pergunta.where(resposta_texto: %w[false False FALSE Falso]).count
        opcoes_stats['falso'] = {
          texto: 'Falso',
          count: falso_count
        }

        @estatisticas[pergunta.id] = {
          tipo: pergunta.tipo,
          total_respostas: respostas_pergunta.count,
          opcoes: opcoes_stats
        }
      end
    end

    # Estatísticas gerais
    @total_submissoes = SubmissaoConcluida.where(formulario: @formulario).count
    @total_respostas = @respostas.count
  end

  private

  def process_respostas
    ActiveRecord::Base.transaction do
      # Gerar UUID anônimo para o usuário (manter anonimato)
      uuid_anonimo = SecureRandom.uuid

      # Salvar cada resposta
      params[:respostas].each do |pergunta_id, resposta_texto|
        pergunta = Perguntum.find(pergunta_id)

        # Validar se a pergunta pertence ao formulário
        raise ActiveRecord::RecordInvalid unless pergunta.template_id == @formulario.template_id

        # Criar resposta baseada no tipo de pergunta
        if pergunta.multipla_escolha?
          # Para múltipla escolha, resposta_texto é o ID da opção
          opcao = OpcoesPerguntum.find(resposta_texto)
          Respostum.create!(
            pergunta: pergunta,
            opcao: opcao,
            formulario: @formulario,
            uuid_anonimo: uuid_anonimo
          )
        else
          # Para verdadeiro/falso e subjetiva
          Respostum.create!(
            pergunta: pergunta,
            resposta_texto: resposta_texto,
            formulario: @formulario,
            uuid_anonimo: uuid_anonimo
          )
        end
      end

      # Marcar como concluído
      SubmissaoConcluida.create!(
        user: current_user,
        formulario: @formulario,
        uuid_anonimo: uuid_anonimo
      )

      redirect_to evaluations_path, notice: 'Respostas enviadas com sucesso! Obrigado pela sua participação.'
    end
  rescue StandardError => e
    Rails.logger.error "Erro ao processar respostas: #{e.message}"
    redirect_to evaluation_path(@formulario), alert: 'Erro ao enviar respostas. Tente novamente.'
  end
end
