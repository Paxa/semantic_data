require "addressable/uri"

module Http
  extend self
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; rv:5.0) Gecko/20100101 Firefox/5.0'

  def normalize_url(url)
    uri = Addressable::URI.parse(url)
    uri.path.sub!(%r{/$}, '') if uri.path != "/"
    uri.path = "/" if uri.path == ""
    uri.to_s
  end

  def get(url, options = {})
    resp = http_request(:get, url, nil, options)
    resp.status < 400 ? resp.body : ""
  end
  
  def post(url, data = nil, options = {})
    resp = http_request(:post, url, data, options)
    resp.status < 400 ? resp.body : ""
  end
  
  def cache_http!
    @original_http_request ||= method(:http_request)
    instance_eval "
    def http_request(method, url, data = nil, options = {})
      caching_http_request(method, url, data, options)
    end"
  end
  
  def stop_cahing_http!
    instance_eval "
    def http_request(method, url, data = nil, options = {})
      @original_http_request(method, url, data, options)
    end"
  end
  
  def caching_http_request(method, url, data = nil, options = {})
    url_for_file = url.to_s.gsub(/https?:\/\//, '').sub(':', '_')
    if data
      url_for_file += '_' + CGI::escape(data.is_a?(Hash) ? data.to_query : data)
    end
    url_for_file += "_#{method.to_s.upcase}"
    file_path = Rails.root + "tmp/http_cache" + url_for_file
    
    if file_path.exist?
      resp = YAML::load(file_path.read)
    else
      resp = @original_http_request.call(method, url, data, options)
      `mkdir -p #{file_path.dirname}`
      File.open(file_path, 'w'){|f| f.write YAML::dump(resp) }
    end
    resp
  end

  def http_request(method, url, data = nil, options = {})
    url = URI.escape(url.to_s)
    slash_pos = url.index('/', 'http://'.size + 1) || url.size
    host = url[0, slash_pos]
    path = url[slash_pos, url.size - slash_pos]

    tries = 0
    begin
      resp = if method == :get
        session_for(host).get(path, options)
      else
        session_for(host).send(method, path, data, options)
      end
    rescue Patron::TimeoutError, Patron::ConnectionFailed, Patron::HostResolutionError, Patron::PartialFileError => e
      if (tries += 1) < 3
        retry
      else
        raise e
      end
    end
  
    return resp
  end

  def http(*args)
    http_request(*args)
  end

  def session_for(base)
    sess = Patron::Session.new
    sess.base_url = base
    sess.connect_timeout = 5
    sess.timeout = 120
    sess.headers['User-Agent'] = USER_AGENT
    sess
  end

end