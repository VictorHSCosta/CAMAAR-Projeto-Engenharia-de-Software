# frozen_string_literal: true

class Disciplina < ApplicationRecord
  belongs_to :curso
  has_many :turmas, dependent: :destroy

  validates :nome, presence: true, length: { minimum: 2 }
end
