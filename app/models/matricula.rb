# frozen_string_literal: true

class Matricula < ApplicationRecord
  belongs_to :user
  belongs_to :turma
end
