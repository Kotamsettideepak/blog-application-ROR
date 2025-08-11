class SessionsController < ApplicationController
  def new
  end

  def create
    puts "CAME TO CREATE DEFINITION IN SESSION........................."
    user = User.find_by({ email: params[:email] })

    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      puts "SESSION CREATED>>>>>>>>>>"
      redirect_to root_path
    else
      flash[:notice] = "invalid user name or password"
      puts "SESSION NOT CREATED >>>>>>>>>>>>>>>>>>>>>>>>>>"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
