require 'redcarpet'
require 'github/markup'

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Hightlighted.render(code, language)
  end
end

module GitHub::Markup
  def markups
    @@markups
  end
end

GitHub::Markup.module_exec do
  markups[/md|mkdn?|mdown|markdown/] = proc do |content|
    markdown = Redcarpet::Markdown.new(HTMLwithPygments, fenced_code_blocks: true)
    markdown.render(content)
  end
end

class Markuped
  def self.render(filename, content = nil)
    filename = Pathname.new(filename)
    content ||= filename.read
    
    GitHub::Markup.render(filename.basename.to_s, content)
  end
end