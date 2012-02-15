# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://microdata.realitysimple.com"
SitemapGenerator::Sitemap.yahoo_app_id = "an12x876"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #add root_path, :priority => 0.7, :changefreq => 'hourly'
  
  add projects_path, :priority => 0.7, :changefreq => 'hourly'
  add history_path, :priority => 0.7, :changefreq => 'hourly'
  add external_resources_path, :priority => 0.7, :changefreq => 'weekly'
  add examples_path, :priority => 0.7, :changefreq => 'weekly'
  add rss_path, :priority => 0.7, :changefreq => 'weekly'
  add posts_path, :priority => 0.7, :changefreq => 'weekly'

  Post.find_each do |post|
    add "/posts/#{post.link}.html", :lastmod => post.updated_at
  end

  Example.find_each do |example|
    add "/examples/#{example.link}", :lastmod => example.updated_at
  end

  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
