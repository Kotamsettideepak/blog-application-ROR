class ApplicationController < ActionController::Base
  include Pundit

  helper_attr :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def loggedin?
    if current_user
      true
    else
      false
    end
  end

  def required_login
    unless loggedin?
      flash[:notice] = "require login"
      redirect_to login_path
    end
  end
end
