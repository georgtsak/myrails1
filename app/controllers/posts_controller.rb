class PostsController < ApplicationController
  def index
    @title = "Post Profile"
    @posts = Post.order(createdon: :desc).all()
  end

  def show
    @post = Post.find(params[:id]) or not_found
  end

  def create
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end

    @user = current_user
    @categories = Category.all()

    if request.get?
      
    elsif request.post?
      @post = Post.new({:title => params[:post][:title], :content => params[:post][:content], :creator => @user, :createdon => Time.now})
      
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

  def delete
  end
end
