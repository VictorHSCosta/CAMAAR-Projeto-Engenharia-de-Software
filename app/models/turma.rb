# frozen_string_literal: true

# Classe responsável por representar turmas
class Turma < ApplicationRecord
  belongs_to :disciplina, optional: true
  belongs_to :professor, class_name: 'User'
  has_many :matriculas, dependent: :destroy
  has_many :alunos, through: :matriculas, source: :user

  validates :semestre, presence: true
end
