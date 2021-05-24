Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, Rails.application.credentials.dig(:development, :omni, :vk_id),
  Rails.application.credentials.dig(:development, :omni, :vk_key)
end
