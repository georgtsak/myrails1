class PostsController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @posts = Post.order(created_at: :desc).all
      @count = Post.all.count
    end
  end

  def show
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @post = Post.find(params[:id]) or not_found
    end
  end

  def my
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @posts = current_user.posts.order(created_at: :desc)
      @count = current_user.posts.all.count
    end
  end

  def create
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
    @user = current_user
    @categories = Category.all()

    if request.get?
      
    elsif request.post?
      @post = @user.posts.create(title: params[:post][:title], content: params[:post][:content])
      current_categories = []

      params[:categories].each do |category|
        found_category = Category.find_by(name: category.downcase)

        if found_category
          current_categories.push(found_category)
        else
          new_category = Category.new(:name => category.downcase)
          if (new_category.save)
            current_categories.push(new_category)
          end
        end
      end

      current_categories.each do |category|
        @post.categories << category
      end

      redirect_to @post
    else
      raise Exception.new "Unimplemented route"
    end
  end
  end

  def delete
  end
end
