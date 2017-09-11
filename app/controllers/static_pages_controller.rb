class StaticPagesController < ApplicationController
  def index 
    @user = User.new
  end

  def new
    @user = User.new
  end
end
