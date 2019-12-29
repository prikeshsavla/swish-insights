class Users::BaseController < ApplicationController
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery

  layout 'users/layouts/application'
  before_action :authenticate_user!
  # before_action :set_paper_trail_whodunnit

  private
  def info_for_paper_trail
    {whodunnit_type: current_user.class.name, whodunnit: current_user.id} if current_user.present?
  end

  def user_not_authorized
    message = 'You are not authorized to perform this action.'
    set_flash_message(message, :warning, now: false)
    redirect_to(request.referrer || user_root_path)
  end

  def render_pdf_for(record, params, locals = {})
    render(
        show_as_html: params[:debug].present?,
        pdf: record.filename,
        template: ['shared', 'layouts', 'pdf_templates', record.class.name.pluralize.underscore, 'show'].join('/'),
        layout: 'shared/layouts/pdf_templates/show',
        page_size: 'A4',
        footer: {
            center: '[page] of [topage]'
        },
        # show_as_html: true,
        locals: {
            record: record
        }.merge(locals)
    )
  end

  protected
  def policy!(user, record)
    CustomPolicyFinder.new(record, namespace).policy!.new(user, record)
  end

  def policy(record)
    policies[record] ||= policy!(pundit_user, record)
  end

  def pundit_policy_scope(scope)
    policy_scopes[scope] ||= policy_scope!(pundit_user, scope)
  end

  def policy_scope!(user, scope)
    CustomPolicyFinder.new(scope, namespace).scope!.new(user, scope).resolve
  end

  def pundit_user
    current_user
  end

  def namespace
    controller_namespace.classify.pluralize
  end

  def controller_namespace
    @controller_namespace ||= controller_path.split('/').first
  end
end
