# frozen_string_literal: true

# Controller responsável por gerenciar avaliações para usuários
class EvaluationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # Buscar formulários que o usuário atual pode ver
    @formularios = Formulario.ativos.no_periodo.select do |formulario|
      formulario.can_be_seen_by?(current_user)
    end
    
    # Separar em formulários disponíveis e já respondidos
    @formularios_disponiveis = @formularios.reject { |f| f.already_answered_by?(current_user) }
    @formularios_respondidos = @formularios.select { |f| f.already_answered_by?(current_user) }
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
    if request.post?
      process_respostas
    end
  end
  
  private
  
  def process_respostas
    begin
      ActiveRecord::Base.transaction do
        # Gerar UUID anônimo para o usuário (manter anonimato)
        uuid_anonimo = SecureRandom.uuid
        
        # Salvar cada resposta
        params[:respostas].each do |pergunta_id, resposta_texto|
          pergunta = Perguntum.find(pergunta_id)
          
          # Validar se a pergunta pertence ao formulário
          unless pergunta.template_id == @formulario.template_id
            raise ActiveRecord::RecordInvalid.new
          end
          
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
    rescue => e
      Rails.logger.error "Erro ao processar respostas: #{e.message}"
      redirect_to evaluation_path(@formulario), alert: 'Erro ao enviar respostas. Tente novamente.'
    end
  end
end
