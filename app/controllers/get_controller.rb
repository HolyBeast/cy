class GetController < ApplicationController
  def races
    Race::NAMES[params[:nation]] ||= []
    keys   = Race::NAMES[params[:nation]]
    values = keys.map{ |key| t(key, scope: :races) }
    races  = Hash[keys.zip(values)]

    respond_to do |format|
      format.json { render :json => races }
    end
  end
end