module PostsHelper
  def post_path(post, options = {})
    post = Post.find(post) unless post.is_a?(Post)
    "/posts/#{post.link}.html"
  end
end
