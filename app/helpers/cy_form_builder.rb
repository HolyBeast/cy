class CyFormBuilder < ActionView::Helpers::FormBuilder
  def submit(label, *args)
    options = args.extract_options!
    new_class = options[:class] || "button"
    
    super(label, *(args << options.merge(:class => new_class)))
  end

  def text_field(label, *args)
    @template.content_tag("div", super(label, *args), :class => 'text-field')
  end

end