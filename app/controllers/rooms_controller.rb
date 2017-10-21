class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms
  end

  def show
  end

  def new
    @users = User.all
    @room = current_user.rooms.new
    @user_rooms = UserRoom.new
  end

  def create
    @room = current_user.rooms.build(create_user_id: current_user.id)
    current_user.save!
    user_room_params[:user_id].each do |param|
      @room.user_rooms.create!(user_id: param)
    end
    redirect_to current_user
  end

  def destroy
  end

  private
    def user_room_params
      params[:room].require(:user_room).permit(user_id: [])
    end
end
