# frozen_string_literal: true

# Classe responsável por representar perguntas dos formulários
class Perguntum < ApplicationRecord
  self.table_name = 'pergunta'

  belongs_to :template
  has_many :opcoes_pergunta, class_name: 'OpcoesPerguntum', foreign_key: 'pergunta_id', dependent: :destroy
  has_many :respostas, class_name: 'Respostum', foreign_key: 'pergunta_id', dependent: :destroy

  # Enum para tipos de pergunta: 0 = verdadeiro_falso, 1 = multipla_escolha, 2 = subjetiva
  enum :tipo, { verdadeiro_falso: 0, multipla_escolha: 1, subjetiva: 2 }

  validates :texto, presence: true, length: { minimum: 3 }
  validates :tipo, presence: true

  scope :ordenadas, -> { order(:id) }

  alias_attribute :titulo, :texto
  attr_accessor :ordem

  def multipla_escolha_ou_verdadeiro_falso?
    multipla_escolha? || verdadeiro_falso?
  end

  # Map virtual attributes before assignment
  def assign_attributes(new_attributes)
    return super unless new_attributes.is_a?(Hash)

    attrs = new_attributes.dup
    attrs[:texto] = attrs.delete(:titulo) if attrs.key?(:titulo)
    attrs.delete(:ordem)
    super(attrs)
  end
end
