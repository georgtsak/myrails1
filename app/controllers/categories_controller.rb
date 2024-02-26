class CategoriesController < ApplicationController
    def index
        @categories = Category.all
    end

    def show
        current_category = Category.find_by(name: params[:id])
        if current_category
            @posts = current_category.posts
            @count = @posts.count
        else
            @posts = nil
            @count = 0
        end
    end
end