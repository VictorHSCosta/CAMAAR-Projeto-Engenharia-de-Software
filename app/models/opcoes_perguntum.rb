# frozen_string_literal: true

# Classe responsável por representar opções de perguntas
class OpcoesPerguntum < ApplicationRecord
  belongs_to :pergunta, class_name: 'Perguntum'
end
