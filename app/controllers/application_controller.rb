# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'lib/authenticated_system'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :session_id, :session_resumed?, :remote_ip, :user_agent, :shopping_cart, :favorites_cart
  before_filter :set_locale

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e2a016b4b4f3ea91c5c24e3d28c9eac0'
  
  # See plugins/restful_authentication
  include AuthenticatedSystem

  # default layout
  layout 'application'

  # Usage:
  # class Site::ShoppingController < ApplicationController
  #   require_privilege Privilege::MY_ACCOUNT
  #   require_privilege Privilege::SHOPPING, :except => :cart
  #   require_privilege Privilege::PAGES, :only => :edit, :delete
  def self.require_privilege(privilege, options = {})
    before_filter options do |controller|
      controller.require_privilege privilege
    end
  end

  protected

  def new_security_path
    '/site/security/login'
  end

  def require_privilege(privilege)
    if privilege
      unless current_user && current_user.has_privilege?(privilege)
        flash[:notice] = "Access denied."
        access_denied
      end
    end
  end

  def set_locale
    I18n.locale = params[:locale] || (current_user.profile.locale if current_user) || session[:locale] || I18n.default_locale
    I18n.load_path += Dir[ File.join(Rails.root, 'lib', 'locales', '*.{rb,yml}') ]
  end

  def session_id
    session[:id] ||= rand(899999999) + 100000000
    return session[:id].to_i
  end

  def session_resumed?
    session_key = ActionController::Base.session[:key]
    return !cookies[session_key].nil?
  end

  def user_agent
    request.headers['HTTP_USER_AGENT']
  end

  def remote_ip
    return request.headers['HTTP_X_FORWARDED_FOR'].blank? ? ( request.headers['HTTP_X_REAL_IP'].blank? ? request.remote_ip : request.headers['HTTP_X_REAL_IP'] ) : request.headers['HTTP_X_FORWARDED_FOR']
  end
  
  def rescue_action_in_public(exception)
    @exception = exception
    case exception
      when ActionController::UnknownAction
        render_404 params[:controller] + '/' + params[:action]
      when ActionController::RoutingError
        render_404 request.env['PATH_INFO']
      when ActiveRecord::RecordNotFound
        render_404 params[:controller] + '/' + params[:id]
      else
        render_500
    end
  end
    
  def local_request?
    false
  end

  def render_503
    render :status => 503, :template => '/errors/maintenance'
  end
  
  def render_500
    render :status => 500, :template => '/errors/internal'
  end
  
  def render_404(missing = nil, message = nil)
    if request.env['HTTP_REFERER']
      logger.warn 'Error 404: ' + request.env['HTTP_REFERER']
    end
    
    @missing = missing
    @message = message
    render :status => 404, :template => '/errors/missing.html'
  end
end