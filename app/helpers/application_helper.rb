module ApplicationHelper
  
  # helpers for google breadcrumbs
  def menu_tag(content, options = {}, &block)
    default_options = {:tag => :li, :itemscope => true, :itemtype => "http://data-vocabulary.org/Breadcrumb"}
    options = default_options.merge(options)
    
    Rails.logger.info([content, options, block])
    if block_given?
      content_tag(options.delete(:tag), options, &block)
    else
      content_tag(options.delete(:tag), content, options)
    end
  end
  
  def menu_link(title, url, options = {})
    link_to(%{<span itemprop="title">#{title}</span>}.html_safe, url, options.merge(:itemprop => "url"))
  end
  
  def page_title(site_title, options = {})
    options = {:seporator => "|"}.merge(options)
    if @page_title
      "#{@page_title} #{options[:seporator]} #{site_title}"
    else
      site_title
    end
  end
  
  def pretty_json_format(obj, opts = {})
    options_map = {}
    options_map[:pretty] = true
    options_map[:indent] = opts[:indent] if opts.has_key?(:indent)
    json = Yajl::Encoder.encode(obj, options_map)
    
    tokens = CodeRay.scan(json, :json)
    tokens.html(:line_numbers => :inline).html_safe
    tokens.span.html_safe
  end
end
