class UsersController < ApplicationController
  def new
    @title = 'register'
    @user  = User.new
    @hero  = @user.build_hero
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      render 'home/index'
    else
      @title = 'register'
      render 'new'
    end
  end
end