require 'pygments'

class Hightlighted
  def self.render(code, language = nil)
    code = Pygments.highlight(code, lexer: language)

    # wrap lines in div
    code.gsub!(/<pre>(.+)<\/pre>/m) do |block|
      lines = $1.strip.gsub("\n", "</div><div>").gsub(%r{<div>\s*</div>}, "<div>&nbsp;</div>")
      "<pre><div>" + lines + "</div></pre>"
    end

    code
  end
end