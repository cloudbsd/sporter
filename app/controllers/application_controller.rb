class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

# before_filter :configure_permitted_parameters, if: :devise_controller?

  # set up user authentiation with devise
  before_filter :authenticate_user!

  before_action :authorize_user!

  protected

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def current_resource
    # method 1: set instance directly
    if params[:id].present?
      instance_name = "@#{controller_name.singularize}"
      instance_value = controller_name.classify.constantize.find_by(id: params[:id])
      instance_variable_set(instance_name, instance_value)
    end

    # method 2: call set_question/set_answer/...
    # method_name = "set_#{controller_name.singularize}"
    # send(method_name) if params[:id].present?
  end

  def authorize_user!
    if !current_permission.allow?(controller_name, params[:action], current_resource)
      @msg = 'You are not authorized to access this page.'
      respond_to do |format|
        format.html { redirect_to (request.env["HTTP_REFERER"].nil? ? groups_path : :back), alert: @msg }
        format.js { render 'shared/permission_failed.js.erb' }
      end
    end
  end

# delegate :allow?, to: :current_permission
# helper_method :allow?

  def can?(action, object, parent = nil)
    if parent.nil?
      current_permission.allow? object.class.to_s.tableize, action, object
    else
      current_permission.allow? object.class.to_s.tableize, action, [object, parent]
    end
  end
  helper_method :can?
end
