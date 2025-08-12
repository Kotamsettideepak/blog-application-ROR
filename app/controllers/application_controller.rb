class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
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

  def valid_user?
    if session[:user_id] && session[:user_agent] != request.user_agent
      reset_session
      flash[:alert] = "Session mismatch detected. Please log in again."
      redirect_to login_path
    end
  end
end
