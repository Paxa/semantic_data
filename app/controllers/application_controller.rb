class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from AbstractController::ActionNotFound, :with => :render_404
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

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
        when OpenURI::HTTPError, Patron::ConnectionFailed, Patron::Error then e.message
        when Timeout::Error, Patron::TimeoutError then "Timeout error"
        when Errno::ENOENT, Patron::HostResolutionError then "Host unreachable"
        else "Unknown error"
      end
    end

    content || nil
  end

  def authenticate_with_http!
    authenticate_or_request_with_http_basic do |username, password|
      username == "Pavel" && Digest::MD5.hexdigest(password) == "ffef23dc7b4c490cb7429b425dcd6716"
    end
  end

  def render_404
    render "welcome/not_found", status: 404
  end
end
