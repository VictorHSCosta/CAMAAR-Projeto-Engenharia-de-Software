# frozen_string_literal: true

# Controller for home page
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_user = current_user
  end
end
