module Public
  class PostsController < ApplicationController
    def index
      @posts = Post.all
    end

    def show
      @post = Post.find_by(title: params[:id].gsub("-", " "))
    end
  end
end
