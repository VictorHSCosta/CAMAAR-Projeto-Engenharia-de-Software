# frozen_string_literal: true

# Classe responsável por representar templates de formulários
class Template < ApplicationRecord
  belongs_to :criado_por, class_name: 'User'
  has_many :pergunta, dependent: :destroy
  has_many :formularios, dependent: :destroy
  
  validates :titulo, presence: true, length: { minimum: 2 }
  validates :publico_alvo, presence: true
end
