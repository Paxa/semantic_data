class ParserController < ApplicationController
  protect_from_forgery except: [:parse_content]
  def get_items
    params[:url] = "http://#{params[:url]}" unless params[:url] =~ %r{^https?:\/\/.*}
  end

  def parse_content
    parse_response("<!DOCTYPE html><html><body>#{params[:html]}</body></html>", params[:page_url], false, true)
  end

  def parse_url
    content = get_content(params[:url])

    if @error_message
      respond_to do |format|
        format.html { render :error, :layout => false }
        format.json { render :json => {:error => @error_message}, :callback => params[:callback] }
      end
      return
    end

    parse_response(content, params[:url])
  end

  def parse_response(content, page_url, save = true, formating = false)
    @doc = Mida::Document.new(content, page_url)
    @doc_hash = @doc.items.map do |item|
      item.to_h
    end

    if save
      if false && parsing = Parsing.where(:url => page_url).first
        parsing.update_attributes(result: content, items_count: @doc.items.size)
        parsing.touch
      else
        parsing = Parsing.create(url: page_url, result: content, items_count: @doc.items.size)
      end
    end

    respond_to do |format|
      format.html { render :parse_url, :layout => false }
      format.json do
        if formating
          render :raw_formated, :layout => false
        else
          render :text => Yajl::Encoder.encode(@doc_hash), :content_type => "application/json"
        end
      end
    end
  end
end
