class UsersController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    @users = User.all
  end
  def show
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    @user = User.find(params[:id])
    @posts = Post.where("creator_id" => @user.id).all
  end
  def me
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    @user = current_user
  end
  def new
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    @user = User.new
  end
  def create
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end
  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password)
  end
end