# frozen_string_literal: true

# Policy for Curso model
class CursoPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.admin? || user.coordenador?
  end

  def update?
    user.admin? || user.coordenador?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
