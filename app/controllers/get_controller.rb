class GetController < ApplicationController
  def races
    Race::NAMES[params[:value]] ||= []
    keys   = Race::NAMES[params[:value]]
    values = keys.map{ |key| t(key, scope: :races) }
    races  = Hash[keys.zip(values)]

    respond_to do |format|
      format.json { render :json => races }
    end
  end

  def map
    map = {}
    width    = 9
    height   = 9
    deepness = 9
    (0..width - 2 + deepness).each do |x|
      (0..height - 2 + deepness).each do |y|
        if y - x < height && x - y < width
          map[x] ||= []
          map[x] << y
        end
      end
    end

    respond_to do |format|
      format.json { render :json => map }
    end
  end
end