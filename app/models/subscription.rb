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

  with_options unless: -> { user.present? } do
    validates :user_email, uniqueness: { scope: :event_id }
    validate :checking_email
  end

  def user_name
    user.present? ? user.name : super
  end

  def user_email
    user.present? ? user.email : super
  end

  private

  def checking_author
    errors.add(:user, :event_owner) if event.user == user
  end

  def checking_email
    errors.add(:user_email, :used_email) if User.find_by(email: user_email)
  end
end
