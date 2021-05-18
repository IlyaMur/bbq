class EventPolicy < ApplicationPolicy
  def show?
    (record.pincode.blank? ||
      (user.present? && user == record.user)) ||
      record.pincode_valid?(cookies["events_#{record.id}_pincode"])
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
