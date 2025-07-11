# frozen_string_literal: true

# Classe responsável por representar perguntas dos formulários
class Perguntum < ApplicationRecord
  belongs_to :template
end
