class UsersController < ApplicationController
  def new
    @title = 'register'
    if request.post?
      @user = User.new(params[:user])
      
      if @user.save
        redirect_to 'home/index'
      end
      
    else
      @user = User.new
      @user.build_hero
    end
  end
end