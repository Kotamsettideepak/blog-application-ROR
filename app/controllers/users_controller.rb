class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    puts @user.inspect

    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user).deliver_later

        format.html { redirect_to login_path, notice: "User was successfully created and welcome email sent." }
        format.json { render :show, status: :created, location: @user }
      else
        puts "ERRORS: #{@user.errors.full_messages}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  def user_params
    params.expect(user: [ :name, :email, :password, :password_confirmation ])
  end
end
