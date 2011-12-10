class ExamplesController < ApplicationController
  def index
    @examples = Example.all
  end
  
  def show
    @example = Example.by_link(params[:id])
  end
  
  def raw
    @example = Example.by_link(params[:id])
    code = @example.source_codes.detect {|f| Pathname.new(f).basename.to_s.sub('.haml', '') == params[:file] }
    @code_title = Pathname.new(code).basename.to_s.sub('.haml', '.html')
    render file: code, layout: 'slim'
  end
end
