class ApplicationPolicy
  attr_reader :context, :record, :cookies, :user

  delegate :cookies, to: :context
  delegate :user, to: :context

  def initialize(context, record)
    @context = context
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def event_for_record_valid?
    event = record.event

    return true if event.user == user
    return false if !event.pincode_valid?(cookies.permanent["events_#{event.id}_pincode"]) && event.pincode.present?

    true
  end

  def current_user_can_delete?
    record.event.user == user || (record.user == user && user.present?)
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
