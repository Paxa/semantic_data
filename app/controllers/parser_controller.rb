class ParserController < ApplicationController
  def get_items
    params[:url] = "http://#{params[:url]}" unless params[:url] =~ %r{^https?:\/\/.*}
  end
  
  def parse_url
    content = get_content(params[:url])
    
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
    
    if parsing = Parsing.where(:url => params[:url]).first
      parsing.update_attributes(result: content, items_count: @doc.items.size)
      parsing.touch
    else
      parsing = Parsing.create(url: params[:url], result: content, items_count: @doc.items.size)
    end
    
    respond_to do |format|
      format.html { render :parse_url, :layout => false }
      format.json { render :text => Yajl::Encoder.encode(@doc_hash), :content_type => "application/json" }
    end
  end
end
