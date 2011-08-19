class ParserController < ApplicationController
  def get_items
    params[:url] = "http://#{params[:url]}" unless params[:url] =~ %r{http:\/\/.*}
  end
  
  def parse_url
    require "open-uri"
    
    begin
      content = open(params[:url]).read
    rescue => e
      Rails.logger.info e.class
      Rails.logger.info e.message
      @error_message = case e
        when URI::InvalidURIError then "Invalid url"
        when SocketError then "nodename nor servname provided, or not known"
        when OpenURI::HTTPError then e.message
        when Timeout::Error then "Timeout error"
        else "Unknown error"
      end
    end
    
    if @error_message
      respond_to do |format|
        format.html { render :error, :layout => false }
        format.json { render :json => {:error => @error_message} }
      end
      return
    end
    
    @doc = Mida::Document.new(content, params[:url])
    @doc_hash = @doc.items.map do |item|
      item.to_h
    end
    
    parsing = Parsing.create(:url => params[:url], :result => content, :items_count => @doc.items.size)
    respond_to do |format|
      format.html { render :parse_url, :layout => false }
      format.json { render :json => @doc_hash }
    end
  end
end
