# frozen_string_literal: true

# Adicione um comentário de documentação para a classe HomeController.
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_user = current_user
  end
end
