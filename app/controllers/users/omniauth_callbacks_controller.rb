class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # replace with your authenticate method
  #skip_before_action :authenticate_user!

  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.where(email: auth["info"]["email"]).first_or_initialize

    is_new_user = user.new_record?
    user.provider = auth["provider"]
    user.uid = auth["uid"]

    if is_new_user
      user.name ||= auth["info"]["name"]
      user.password = Devise.friendly_token[0, 20]
    end
    user.save!

    user.remember_me = true
    sign_in(:user, user)
    if is_new_user
      redirect_to after_sign_up_path_for(user)
    else
      redirect_to after_sign_in_path_for(user)
    end
  end

  private

  def after_sign_up_path_for(resource)
    new_users_swish_path
  end

  def after_sign_in_path_for(resource_or_scope)
    new_users_swish_path
  end
end