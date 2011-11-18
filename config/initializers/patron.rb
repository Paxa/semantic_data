class Patron::Response
  def determine_charset(header_data, body)
    header_data.match(charset_regex) || (body && body.match(charset_regex))
    if $1
      $1
    else
      encoding = CharDet.detect(body)
      encoding[:encoding].name.upcase
    end
  end
end

#encoding = CharDet.detect(file_content)
#converter = Encoding::Converter.new(encoding[:encoding].name.upcase, "UTF-8")
#converter.convert(file_content)