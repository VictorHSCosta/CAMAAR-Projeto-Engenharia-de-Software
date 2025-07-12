# frozen_string_literal: true

# Adicione um comentário de documentação para a classe HomeController.
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_user = current_user
    
    # Redireciona admins para o gerenciamento se não houver dados importados
    if current_user.admin?
      seed_emails = ['admin@camaar.com', 'coordenador@camaar.com', 'professor@camaar.com', 'aluno@camaar.com']
      users_count = User.where.not(email: seed_emails).count
      disciplinas_count = Disciplina.count
      
      if users_count == 0 || disciplinas_count == 0
        redirect_to admin_management_path, notice: 'Para começar, importe os dados do SIGAA.'
        return
      end
    end
  end
end
