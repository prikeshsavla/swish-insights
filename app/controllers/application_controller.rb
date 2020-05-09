class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :allow_pwa])
  end

  private

  def set_flash(object, action, sentiment: :info, now: false)
    flash_hash = now ? flash.now : flash
    flash_hash[sentiment] = flash_message(object, action)
  end

  def set_flash_message(message, sentiment, now: false)
    flash_hash = now ? flash.now : flash
    flash_hash[sentiment] = message
  end

  def flash_message(object, action)
    class_name = object.class.name.titleize

    case action.to_sym
    when :create
      "#{class_name} has been successfully created."
    when :update
      "#{class_name} has been successfully updated."
    when :destroy
      "#{class_name} has been successfully destroyed."
    else
      "#{class_name} has been successfully changed."
    end
  end
end
