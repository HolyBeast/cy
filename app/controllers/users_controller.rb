class UsersController < ApplicationController
  def new
    @title = 'register'
    @user = User.new
    @user.build_hero
    @race = Race::NAMES['klum']
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      render 'home/index'
    else
      @title = 'register'
      @race = Race::NAMES[params[:user][:hero_attributes][:nation]]
      @race = Race::NAMES['klum'] if @race.empty?

      render 'new'
    end
  end

  def get_races
    Race::NAMES[params[:nation]] ||= []
    keys   = Race::NAMES[params[:nation]]
    values = keys.map{ |key| t(key, scope: :races) }
    races  = Hash[keys.zip(values)]

    respond_to do |format|
      format.json { render :json => races }
    end
  end
end