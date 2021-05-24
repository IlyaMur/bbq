class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    oauth_action('facebook')
  end

  def vkontakte
    oauth_action('vkontakte')
  end

  private

  def oauth_action(type)
    @user = FindUserOauthService.find_user(request.env['omniauth.auth'])

    if @user.persisted?
      set_flash_message(:notice, :success, kind: type) if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      set_flash_message(:notice, :failure, kind: type, reason: 'error')
      redirect_to new_user_registration_url
    end
  end
end
