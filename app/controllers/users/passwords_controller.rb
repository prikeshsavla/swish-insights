class Users::PasswordsController < Devise::PasswordsController
  layout 'users/layouts/application'


  protected

    def after_resetting_password_path_for(resource_or_scope)
      sign_out(resource)
      new_user_session_path
    end
end
