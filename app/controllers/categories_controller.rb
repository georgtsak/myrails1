class CategoriesController < ApplicationController
    def index

    end

    def show
        current_category = Category.find_by(name: params[:id])
        if current_category
            posts_by_id = PostsCategory.where("category_id" => current_category.id).select("post_id").all()
            @posts = Post.where(id: posts_by_id).order(createdon: :desc).all()
        else
            @posts = nil
        end
    end
end