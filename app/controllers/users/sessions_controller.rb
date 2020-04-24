class Users::SessionsController < Devise::SessionsController
  layout 'users/layouts/application'

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    reset_session
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    new_users_swish_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
