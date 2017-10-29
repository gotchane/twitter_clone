class RoomsController < ApplicationController
  before_action :set_room, only:[:show, :destroy, :mark_read]
  before_action :set_user_room, only:[:show, :destroy]

  def index
    @rooms = current_user.rooms.check_available(true).sort_by_message_created
  end

  def show
    @messages = @room.messages.after_history_deletion(@user_room.datetime_last_history_deleted)
                              .order(created_at: :desc)
    @message_post = current_user.messages.new
  end

  def new
    @room = current_user.rooms.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    @room.current_user = current_user
    if @room.save
      redirect_to user_room_path(current_user, @room)
    else
      render 'new'
    end
  end

  def mark_read
    @message = @room.messages.order(created_at: :desc).first
    @message.current_user = current_user
    @message.mark_last_read_message
    render json: {status: "OK", code: 200}
  end

  def destroy
    @user_room.delete_messages_history
    redirect_to user_rooms_path(current_user), success: "Messages history deleted successfully!"
  end

  private
    def set_room
      @room = current_user.rooms.check_available(true).find(params[:id])
    end

    def set_user_room
      @user_room = @room.user_rooms.find_by(user: current_user)
    end

    def room_params
      params.require(:room).permit(:create_user_id, user_ids: [])
    end
end
