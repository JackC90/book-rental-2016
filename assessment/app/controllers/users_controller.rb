class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	respond_to do |format|
  		if @user.save
  			format.html { redirect_to root_path, notice: "Account was successfully created." }
  			format.json { render :show, status: :created, location: @user }
  		else
  			format.html { render "users/new", notice: "Failed to create account." }
  			format. json { render json: @user.errors, status: :unprocessable_entity }
  		end
  	end
  end

  private
  def user_params
  	params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end