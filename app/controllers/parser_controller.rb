class ParserController < ApplicationController
  def get_items
    params[:url] = "http://#{params[:url]}" unless params[:url] =~ %r{http:\/\/.*}
  end
  
  def parse_url
    require "open-uri"
    content = open(params[:url]).read
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
