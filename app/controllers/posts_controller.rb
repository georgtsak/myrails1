class PostsController < ApplicationController
  def index
    @title = "Post Profile"
    @posts = Post.all()
  end

  def show
    @post = Post.find(params[:id]) or not_found
  end

  def create
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end

    @user = current_user

    if request.get?
      
    elsif request.post?
      @post = Post.new({:title => params[:post][:title], :content => params[:post][:content], :creator => @user, :createdon => Time.now})

      if @post.save
        @success_messages = 'Successfully created!'
      else
        @error_messages = [ 'Something gone wrong while creating a post...' ]
      end

    else
      raise Exception.new "Unimplemented route"
    end
  end

  def delete
  end
end
