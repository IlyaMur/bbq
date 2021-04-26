class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :user_name,
            presence: true,
            unless: -> { user.present? }

  validates :user_email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            unless: -> { user.present? }

  with_options if: -> { user.present? } do
    validates :user, uniqueness: { scope: :event_id }
    validate :is_user_event_owner
  end

  with_options unless: -> { user.present? } do
    validates :user_email, uniqueness: { scope: :event_id }
    validate :is_email_already_used
  end

  def user_name
    user&.name || super
  end

  def user_email
    user&.email || super
  end

  private

  def is_user_event_owner
    errors.add(:user, :event_owner) if event.user == user
  end

  def is_email_already_used
    errors.add(:user_email, :used_email) if User.find_by(email: user_email)
  end
end
