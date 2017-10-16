class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def new
  end

  def create
  end

  def destroy
  end
end
