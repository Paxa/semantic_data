class Patron::Response
  def initialize(url, status, redirect_count, header_data, body, default_charset = nil)
    # Don't let a response clear out the default charset, which would cause encoding to fail
    default_charset = "ASCII-8BIT" unless default_charset
    @url            = url
    @status         = status
    @redirect_count = redirect_count
    @body           = body

    parse_headers(header_data)
    @charset        = determine_charset(header_data, body) || default_charset

    [url, header_data].each do |attr|
      convert_to_default_encoding!(attr)
    end

    parse_headers(header_data)
    if @headers["Content-Type"] && @headers["Content-Type"][0, 5] == "text/"
      convert_to_default_encoding!(@body)
    end
  end

  def determine_charset(header_data, body)
    header_data.match(charset_regex) || (body && body.match(charset_regex))
    if $1
      $1
    elsif header_data.index('text/')
      encoding = CharDet.detect(body)
      encoding[:encoding].name.upcase
    end
  end
end