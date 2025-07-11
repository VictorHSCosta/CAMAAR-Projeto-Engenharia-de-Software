# frozen_string_literal: true

# Classe responsável por representar templates de formulários
class Template < ApplicationRecord
  belongs_to :criado_por, class_name: 'User'
end
