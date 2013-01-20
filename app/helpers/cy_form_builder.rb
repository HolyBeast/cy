class CyFormBuilder < SimpleForm::FormBuilder
  def input(name, options = {}, &block)  
    if options[:collection]
      options[:prompt] = false
    end

    options[:input_html] ||= {}
    options[:label_html] ||= {}

    if !object.errors[name.to_sym].blank?
      options[:input_html].merge! :class => 'error'
      options[:label_html].merge! :class => 'error'
    end

    super
  end

  def submit(name, options = {}, &block)
    @template.content_tag('div', super, :class => 'field')
  end
end