class CommentPolicy < ApplicationPolicy
  def create?
    event_for_record_valid?
  end

  def destroy?
    current_user_can_delete?
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
