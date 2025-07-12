# frozen_string_literal: true

# Classe responsável por representar formulários de avaliação
class Formulario < ApplicationRecord
  belongs_to :template
  belongs_to :turma
  belongs_to :coordenador, class_name: 'User'
  has_many :resposta, dependent: :destroy
end
