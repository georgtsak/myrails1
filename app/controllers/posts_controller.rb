class PostsController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      @posts = Post.order(created_on: :desc).all()
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
      @posts = Post.where("creator_id" => current_user.id).all()
      render index
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
      @post = Post.new({:title => params[:post][:title], :content => params[:post][:content], :creator => @user})
      
      if @post.save
        @message = 'Successfully created!'
        @error = false

        params[:categories].each do |category|
          temp_item = Category.find_by(name: category)
  
          if temp_item
            posts_category = PostsCategory.new({:post => @post, :category => temp_item})
            if posts_category.save
            else
              @message = 'Cant attach a category to a post.'
              @error = true
            end
          else
            new_category = Category.new({:name => category})
            if new_category.save
              posts_category = PostsCategory.new({:post => @post, :category => new_category})
              if posts_category.save
              else
                @message = 'Cant attach a category to a post.'
                @error = true
              end
            else
              @message = 'Cant create a category.'
              @error = true
            end
          end
        end
      else
        @message = 'Cant create a post.'
        @error = true
      end
    else
      raise Exception.new "Unimplemented route"
    end
  end
  end

  def delete
  end
end
