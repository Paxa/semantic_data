class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  def get_content(url)
    require "open-uri"
    require "timeout"

    begin
      content = Http.get(url)
    rescue => e
      Rails.logger.info e.class
      Rails.logger.info e.message
      @error_message = case e
        when URI::InvalidURIError then "Invalid url"
        when SocketError then "nodename nor servname provided, or not known"
        when OpenURI::HTTPError, Patron::ConnectionFailed then e.message
        when Timeout::Error, Patron::TimeoutError then "Timeout error"
        when Errno::ENOENT, Patron::HostResolutionError then "Host unreachable"
        else "Unknown error"
      end
    end
    
    content || nil
  end
end
