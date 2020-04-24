class Users::RegistrationsController < Devise::RegistrationsController
  layout 'users/layouts/application'

  private

  def after_sign_up_path_for(resource)
    new_users_swish_path
  end
end
