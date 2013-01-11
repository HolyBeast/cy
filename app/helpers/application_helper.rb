module ApplicationHelper
  # Retourne un titre basé sur la page.
  def title
    baseTitle = "Terres de Cy"
    if @title.nil?
      baseTitle
    else
      "#{@title} ~ #{baseTitle}"
    end
  end
  
  def cy_form_for(name, *args, &block)
    options = args.extract_options!
 
    form_for(name, *(args << options.merge(:builder => CyFormBuilder)), &block)
  end 
end