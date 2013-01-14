class UsersController < ApplicationController
  def register
    @title = "S'engager"
    @user  = User.new
    @hero  = @user.build_hero
  end

  def create
    @user = User.new(params[:user])

    if @user.save
    else
      @title = "S'engager"
      render 'register'
    end
  end
end