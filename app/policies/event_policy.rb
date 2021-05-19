class EventPolicy < ApplicationPolicy
  def show?
    return true if record.pincode.blank?
    return true if user == record.user
    return true if record.pincode_valid?(cookies["events_#{record.id}_pincode"])

    false
  end

  def create?
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
    record.user == user
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
