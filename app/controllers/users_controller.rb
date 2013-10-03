class UsersController < ApplicationController
  before_action :login_required, :except => [:new, :create]
  before_action :set_user, only: [:new,:edit,:update]

  def new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end

   private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(user_params)
    end

      # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
