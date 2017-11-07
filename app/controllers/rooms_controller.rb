class RoomsController < ApplicationController
  before_action :set_room, only:[:show, :destroy]

  def index
    @rooms = current_user.rooms.check_available(true).sort_by_message_created
  end

  def show
    @messages = @room.messages.after_history_deletion(@room.datetime_last_history_deleted(current_user))
                              .order(created_at: :desc)
    @message_post = current_user.messages.new
  end

  def new
    @room = current_user.rooms.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    unused_room = @room.existing_unused_room
    if !unused_room.nil?
      unused_room.reactivate_participant
      redirect_to user_room_path(current_user, unused_room)
    elsif @room.save
      redirect_to user_room_path(current_user, @room)
    else
      render 'new'
    end
  end

  def destroy
    @room.delete_messages_history(current_user)
    redirect_to user_rooms_path(current_user), success: "Messages history deleted successfully!"
  end

  private
    def set_room
      @room = current_user.rooms.check_available(true).find(params[:id])
    end

    def room_params
      params.require(:room).permit(:create_user_id, user_ids: [])
    end
end
