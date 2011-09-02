require "base64"
module Sass::Script::Functions
  
  def file_mime_type(ext)
    case ext.sub(".", "")
      when "png" then "image/png"
      when "jpg" then "image/jpeg"
      when "jpeg" then "image/jpeg"
      when "gif" then "image/gif"
    end
  end
  
  def base64(path)
    assert_type path, :String
    
    filepath = Rails.root + "public/images" + path.value
    
    return Sass::Script::String.new('none') unless filepath.exist?
    #return Sass::Script::String.new "url(/images/#{path.value})" if Rails.env.development?
    
    content = Base64.strict_encode64(filepath.read)
    prefix  = "data:#{file_mime_type(filepath.extname)};base64,"
    
    Sass::Script::String.new "url(#{prefix}#{content})"
  end
  
  declare :base64, :args => [:string]
end

Sass::Plugin.options[:template_location] = 'app/stylesheets'
Sass::Plugin.options[:style] = Rails.env.development?? :expanded : :compressed
