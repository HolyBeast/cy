class HomeController < ApplicationController
  def index
    @title = 'home'
  end

  def map
    @title = 'Carte 2D Iso'
  end
end
