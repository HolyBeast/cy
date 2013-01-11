class HeroController < ApplicationController
  def register
    @title = 'S\'engager'
    @races = Constant::RACES
  end
end