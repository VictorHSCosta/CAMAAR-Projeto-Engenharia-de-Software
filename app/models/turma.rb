# frozen_string_literal: true

# Classe responsável por representar turmas
class Turma < ApplicationRecord
  belongs_to :disciplina
  belongs_to :professor, class_name: 'User'
end
