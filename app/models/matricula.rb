# frozen_string_literal: true

class Matricula < ApplicationRecord
  belongs_to :user
  belongs_to :turma
  has_one :disciplina, through: :turma

  validates :situacao, inclusion: { in: %w[matriculado aprovado reprovado] }
  # NOTE: This uniqueness validation might need a database index for better performance
  validates :user_id, uniqueness: { scope: :turma_id, message: 'já está matriculado nesta turma' }

  before_validation :set_default_situacao

  # Helper method to get the student (aluno) associated with this matricula
  def aluno
    user if user&.aluno?
  end

  private

  def set_default_situacao
    self.situacao ||= 'matriculado'
  end
end
