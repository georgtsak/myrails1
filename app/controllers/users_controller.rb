class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end
  def add_contact
    @user = current_user
    @contact = @user.contacts.build(recipient_id: params[:recipient_id])

    if @contact.save
      flash[:success] = "Contact added successfully!"
    else
      flash[:error] = "Unable to add contact."
    end

    redirect_to users_path
  end
  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
