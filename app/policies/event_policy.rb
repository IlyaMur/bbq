class EventPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    event_owner?
  end

  def edit?
    event_owner?
  end

  def destroy?
    event_owner?
  end

  private

  def event_owner?
    user.present? && record.user == user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
