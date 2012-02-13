module ApplicationHelper

  # helpers for google breadcrumbs
  def menu_tag(content, options = {}, &block)
    default_options = {:tag => :li, :itemscope => true, :itemtype => "http://data-vocabulary.org/Breadcrumb"}
    options = default_options.merge(options)

    if block_given?
      content_tag(options.delete(:tag), options, &block)
    else
      content_tag(options.delete(:tag), content, options)
    end
  end

  def rss_link(options)
    #%link{rel="alternate" type="application/rss+xml" title="RSS" href="http://semantic_datas.dev/rss/feed.rss?url=http%3A%2F%2Fsemantic_datas.dev%2Fposts")
    default_options = {:rel => :alternate, :type => "application/rss+xml", :title => :RSS}
    tag(:link, default_options.merge(options))
  end

  def rss_self_url
    #http://semantic_datas.dev/rss/feed.rss?url=http%3A%2F%2Fsemantic_datas.dev%2Fposts
    posts_url = "http://#{HOST}/posts"
    "http://#{HOST}/rss/feed.rss?#{Rack::Utils.universal_build(:url => posts_url)}"
  end

  def menu_link(title, url, options = {})
    link_to(%{<span itemprop="title">#{title}</span>}.html_safe, url, options.merge(:itemprop => "url"))
  end

  def page_title(site_title, options = {})
    options = {:seporator => ":"}.merge(options)
    if @page_title
      "#{@page_title}"
    else
      site_title
    end
  end

  def pretty_json_format(obj, opts = {})
    options_map = {}
    options_map[:pretty] = true
    options_map[:indent] = opts[:indent] if opts.has_key?(:indent)
    json = Yajl::Encoder.encode(obj, options_map)

    raw Hightlighted.render(json, 'javascript')
  end
end
