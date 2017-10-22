class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms
  end

  def show
  end

  def new
    @users = User.all
    @room = current_user.rooms.new
    @user_rooms = current_user.rooms.new
  end

  def create
    @room = current_user.rooms.build(create_user_id: current_user.id)
    current_user.save!
    user_room_params.each do |param|
      @room.user_rooms.create!(user_id: param)
    end
    redirect_to user_room_path(current_user, @room)
  end

  def destroy
  end

  private
    def user_room_params
      params[:room].require(:room).permit(user_ids: [])[:user_ids]
    end
end
