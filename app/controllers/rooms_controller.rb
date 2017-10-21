class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms
  end

  def show
  end

  def new
  end

  def create
  end

  def destroy
  end
end
