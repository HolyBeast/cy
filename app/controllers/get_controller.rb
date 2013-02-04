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
    size = 50
    (1..size).each do |x|
      (1..size).each do |y|
        type = 'herb'

        if (x == 10 && y == 10) || (x == 1 && y == 1) || (x == 4 && y == 5) || (x == 50 && y == 50)
          type = 'water'
        end

        map[x] ||= []
        map[x][y] = {t: type}
      end
    end

    File.open('map.json', 'w+') do |f|
     f.write(map.to_json)
    end

    respond_to do |format|
      format.json { render :json => map }
    end
  end
end