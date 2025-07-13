# frozen_string_literal: true

# Classe responsável por rastrear quais usuários já responderam quais formulários
class SubmissaoConcluida < ApplicationRecord
  self.table_name = 'submissoes_concluidas'
  
  belongs_to :user
  belongs_to :formulario

  validates :user_id, uniqueness: { scope: :formulario_id }
end
