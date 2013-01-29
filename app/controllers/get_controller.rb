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
    size = 3
    (0..size - 2 + size).each do |x|
      (0..size - 2 + size).each do |y|
        if (y - x).abs < size
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