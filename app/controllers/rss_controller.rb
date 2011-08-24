class RssController < ApplicationController
  def index
    
  end
  
  def feed
    
    content = get_content(params[:url])

    if @error_message
      respond_to do |format|
        format.rss  { render :xml => {:error => @error_message} }
        format.atom { render :xml => {:error => @error_message} }
      end
      return
    end
    
    @doc = Mida::Document.new(content, params[:url])
    
    @blog_item = @doc.search(%r{http://schema.org/Blog}).first
    
    @posts = @blog_item.properties["blogPosts"].map do |post_item|
      {
        :title => post_item.get_string_prop(:name),
        :body => post_item.get_string_prop(:articleBody),
        :date => post_item.get_prop(:datePublished).first,
        :url => post_item.get_string_prop(:url)
      }
    end
    
    @blog = {
      :title => @blog_item.get_prop(:name).try(:join, " ") || @doc.doc.css('title').first.content,
      :description => @blog_item.get_string_prop(:description),
      :link => params[:url],
      :updated_at => @posts.sort {|a, b| a[:date] <=> b[:date] }.last[:date]
    }
    
    @blog[:author] = @blog_item.get_string_prop(:author) || @doc.doc.css('[rel=author]').first.content
    
    Rails.logger.info([@blog, @posts])
    
    #render :text => ""
  end
end
