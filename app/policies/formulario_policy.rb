# frozen_string_literal: true

# Policy for Formulario authorization
class FormularioPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.admin? || user&.coordenador?
  end

  def update?
    user&.admin? || user&.coordenador?
  end

  def destroy?
    user&.admin? || user&.coordenador?
  end
end
