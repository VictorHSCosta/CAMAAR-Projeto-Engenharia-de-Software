# frozen_string_literal: true

# Classe responsável por representar respostas aos formulários
class Respostum < ApplicationRecord
  self.table_name = 'resposta'
  
  belongs_to :formulario
  belongs_to :pergunta, class_name: 'Perguntum', foreign_key: 'pergunta_id'
  belongs_to :opcao, class_name: 'OpcoesPerguntum', foreign_key: 'opcao_id'
  belongs_to :turma
end
