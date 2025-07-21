# frozen_string_literal: true

# Classe responsável por representar respostas aos formulários
class Respostum < ApplicationRecord
  self.table_name = 'resposta'

  # Associações
  belongs_to :formulario
  belongs_to :pergunta, class_name: 'Perguntum'
  belongs_to :opcao, class_name: 'OpcoesPerguntum', optional: true
  belongs_to :turma, optional: true

  # Validações
  validates :uuid_anonimo, presence: true
  validates :resposta_texto, presence: true, if: -> { opcao_id.blank? }
  validates :opcao_id, presence: true, if: -> { resposta_texto.blank? }
end
