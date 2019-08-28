class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      # flash[:info] = "Please check your email to activate your account."
      NotificationMailer.send_confirm_to_user(@user).deliver
      @user.update_attribute(:activated,    true)
      @user.update_attribute(:activated_at, Time.zone.now)
      sign_in @user
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      NotificationMailer.send_confirm_to_user(@user).deliver
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end
end
