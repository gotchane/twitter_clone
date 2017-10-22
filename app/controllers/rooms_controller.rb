class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms.sort_by_message_created
  end

  def show
    @room = current_user.rooms.find(params[:id])
    @messages = @room.messages.order(id: "ASC")
    @message_post = current_user.messages.new
  end

  def new
    @users = User.all
    @room = current_user.rooms.new
    @user_rooms = @room.user_rooms.new
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
      params[:room].require(:user_room).permit(user_id: [])[:user_id]
    end
end
