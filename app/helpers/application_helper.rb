module ApplicationHelper
  # Retourne un titre basé sur la page.
  def title
    baseTitle = "Terres de Cy"
    if @title.nil?
      baseTitle
    else
      t('title.' + @title) + " ~ #{baseTitle}"
    end
  end
end