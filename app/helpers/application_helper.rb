module ApplicationHelper
  def auth_buttons(action, jqm_options, *arr)
    content_tag(:ul, nil, :class => 'buttons white') {
      arr.reduce('') { |result, provider|
        options = jqm_options.merge!({:class => provider})
        result << content_tag(:li, link_to("#{t(action)} #{provider.camelize}", "#{action}/#{provider}", options))
      }.html_safe
    }    
  end
  
  def with_format(format, &block)
    old_formats = formats
    begin
      self.formats = [format]
      block.call
    ensure
      self.formats = old_formats
    end
    nil
  end  
end
