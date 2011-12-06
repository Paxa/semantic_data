namespace :posts do
  task :reload => :environment do
    
    require 'redcarpet'
    require 'pygments'
    require 'github/markup'
    
    class HTMLwithPygments < Redcarpet::Render::HTML
      def block_code(code, language)
        code = Pygments.highlight(code, lexer: language)

        # wrap lines in div
        code.gsub!(/<pre>(.+)<\/pre>/m) do |block|
          lines = $1.strip.gsub("\n", "</div><div>").gsub(%r{<div>\s*</div>}, "<div>&nbsp;</div>")
          "<pre><div>" + lines + "</div></pre>"
        end
        
        code
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
    
    (Rails.root + "posts").entries.each do |file| 
      next if file.to_s[0, 1] == '.'
      Post.from_file(Rails.root + "posts" + file)
    end
  end
end