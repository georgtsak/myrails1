class PostsController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to '/users/sign_in'
    else
      title_key = "%#{params[:title]}%"
      content_key = "%#{params[:content]}%"

      title_exists = !params[:title].blank?
      content_exists = !params[:content].blank?

      if title_exists && content_exists
        post_scope = Post.where("content LIKE ?", title_key, " OR title LIKE ?", content_key).all
      elsif title_exists && !content_exists
        post_scope = Post.where("title LIKE ?", title_key).all
      elsif !title_exists && content_exists
        post_scope = Post.where("content LIKE ?", content_key).all
      else
        post_scope = Post.all
      end

      @search_content_value = params[:content]
      @search_title_value = params[:title]

      @pagy, @posts = pagy(post_scope.all.order(created_at: :desc), items: 10)
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
      @pagy, @posts = pagy(current_user.posts.order(created_at: :desc), items: 10)

      @count = current_user.posts.count
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
