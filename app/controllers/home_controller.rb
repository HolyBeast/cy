class HomeController < ApplicationController
  def index
    @title = 'home'
  end

  def map
    @title = 'map'
  end
end
