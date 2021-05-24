class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      set_flash_message(:notice, :failure, kind: kind, reason: 'ошибка авторизации')
      redirect_to new_user_registration_url
    end
  end
end

