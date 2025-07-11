class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user # Torna current_user disponível nas views

  before_action :require_login # Garante que require_login está definido como callback

  # Encontra o usuário logado atualmente, se existir
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Retorna true se o usuário estiver logado, false caso contrário
  def logged_in?
    !!current_user
  end

  # O método que protege as páginas
  def require_login
    return if logged_in?

    flash[:error] = "Você precisa estar logado para acessar esta página."
    redirect_to login_path # Redireciona para a tela de login
  end
end
