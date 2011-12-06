ActionView::Base.field_error_proc = Proc.new do |input, instance|
  (input.gsub(/<(input|label|select|textarea)/) {|match|
    %{#{match} class="field_with_errors"}
  }).html_safe
end