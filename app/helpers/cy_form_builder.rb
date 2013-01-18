class CyFormBuilder < SimpleForm::FormBuilder
  def input(name, options = {}, &block)
    hint_text  = hint(name).slice(5..-7)
    error_text = object.errors[name.to_sym].blank? ? nil : object.errors[name.to_sym].first
    
    title_text = ''
    title_text << "#{hint_text}" if !hint_text.blank?
    title_text << "<br /><br />" if !hint_text.blank? && !error_text.nil?
    title_text << "<span style=\"color: #c22\">#{error_text}</span>" if !error_text.nil?

    label_class = error_text.nil? ? nil : 'error'

    if options[:collection]
      options[:prompt] = false
    end

    options[:input_html] ||= {}
    options[:label_html] ||= {}

    if !label_class.nil?
      options[:input_html].merge! :class => label_class
      options[:label_html].merge! :class => label_class
    end

    if !title_text.blank?
      options[:input_html].merge! :title => title_text
    end

    super
  end

  def submit(name, options = {}, &block)
    @template.content_tag('div', super, :class => 'field')
  end
end