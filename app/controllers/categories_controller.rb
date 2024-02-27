class CategoriesController < ApplicationController
    include Pagy::Backend

    def index
        name_key = "%#{params[:name]}%"
  
        name_exists = !params[:name].blank?
  
        if name_exists
          categories_scope = Category.where("name LIKE ?", name_key).all
        else
            categories_scope = Category.all
        end
  
        @search_name_value = params[:name]

        @pagy, @categories = pagy(categories_scope.order(created_at: :desc), items: 40)
        @count = @categories.count
    end

    def show
        current_category = Category.find_by(name: params[:id])
        if current_category
            title_key = "%#{params[:title]}%"
            content_key = "%#{params[:content]}%"
      
            title_exists = !params[:title].blank?
            content_exists = !params[:content].blank?

            post_scope = current_category.posts
      
            if title_exists && content_exists
              post_scope = post_scope.where("content LIKE ?", title_key, " OR title LIKE ?", content_key).all
            elsif title_exists && !content_exists
              post_scope = post_scope.where("title LIKE ?", title_key).all
            elsif !title_exists && content_exists
              post_scope = post_scope.where("content LIKE ?", content_key).all
            else
              post_scope = post_scope.all
            end
      
            @search_content_value = params[:content]
            @search_title_value = params[:title]
      
            @pagy, @posts = pagy(post_scope.all.order(created_at: :desc), items: 10)
            @count = current_category.posts.count
        else
            @posts = nil
            @count = 0
        end
    end
end