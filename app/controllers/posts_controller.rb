class PostsController < ApplicationController
  def index
    @posts = Post.order("id desc").limit(10).all
  end
  
  def show
    @post = Post.where(:link => params[:id]).first
  end
end
