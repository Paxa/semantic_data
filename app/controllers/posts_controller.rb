class PostsController < ApplicationController
  def index
    @posts = Post.order("id desc").limit(10).all
  end
  
  def show
    if params[:id] =~ /^\d+$/
      @post = Post.find(params[:id])
    else
      @post = Post.where(:link => params[:id]).first
      raise ActiveRecord::RecordNotFound, "Post not fount" unless @post
    end
  end
end
