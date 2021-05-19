class CommentPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    event_for_record_valid?
  end

  def destroy?
    record.event.user == user || record.user == user
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
