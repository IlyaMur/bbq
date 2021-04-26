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
    validate :checking_author
  end

  validates :user_email,
            uniqueness: { scope: :event_id },
            unless: -> { user.present? }

  def user_name
    user.present? ? user.name : super
  end

  def user_email
    user.present? ? user.email : super
  end

  private

  def checking_author
    return unless event.user == user
    errors.add(:user, :event_owner)
  end
end
