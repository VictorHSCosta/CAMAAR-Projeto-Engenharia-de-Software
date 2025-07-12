# frozen_string_literal: true

# Classe responsável por representar respostas aos formulários
class Respostum < ApplicationRecord
  belongs_to :formulario
  belongs_to :pergunta, class_name: 'Perguntum'
  belongs_to :opcao, class_name: 'OpcoesPerguntum'
  belongs_to :turma
end
