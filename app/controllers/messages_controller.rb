class MessagesController < ApplicationController
  before_action :set_room

  def new
    @message = current_user.messages.new(room_id: @room.id)
  end

  def create
    @message = current_user.messages.build(message_params)
    @message.room_id = @room.id
    @user_room = @room.user_rooms.find_by(user: current_user)
    if @message.save
      @room.reactivate_participant if @room.unavailable_participant?
      @user_room.mark_last_read_message(@message)
      redirect_to user_room_path(current_user,@room), success: "Post message succeeded!"
    else
      @message_post = @message
      @user = current_user
      @messages = @room.messages
      render template: 'rooms/show'
    end
  end

  def destroy
    @message = current_user.messages.find_by(id: params[:id])
    @message.destroy
    redirect_to request.referrer, success: "Message deleted successfully!"
  end

  private
    def set_room
      @room = current_user.rooms.find(params[:room_id])
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
