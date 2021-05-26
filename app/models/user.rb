class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: %i[facebook
                                                             vkontakte]

  mount_uploader :avatar, AvatarUploader

  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions

  validates :name, presence: true, length: { maximum: 35 }
  before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.find_for_oauth(access_token)
    email = access_token.info.email
    name = access_token.info.name

    return if email.nil?

    user = where(email: email).first

    return user if user.present?

    provider = access_token.provider
    id = access_token.extra.raw_info.id

    case provider
    when 'facebook'
      url = "https://facebook.com/#{id}"
      avatar_url = access_token.info.image.gsub('http', 'https')
    when 'vkontakte'
      url = "https://vk.com/id#{id}"
      avatar_url = access_token.extra.raw_info.photo_400_orig
    end

    where(url: url, provider: provider).first_or_create! do |user|
      user.name = name
      user.email = email
      user.remote_avatar_url = avatar_url
      user.password = Devise.friendly_token.first(16)
    end
  end

  private

  def set_name
    self.name = "Человек №#{rand(1000)}" if name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: email).update_all(user_id: id)
  end
end
