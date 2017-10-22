class MessagesController < ApplicationController
  before_action :set_room

  def new
    @message = current_user.messages.new(room_id: @room.id)
  end

  def create
    @message = current_user.messages.build(message_params)
    @message.room_id = @room.id
    if @message.save
      redirect_to user_room_path(current_user,@room), success: "Post message succeeded!"
    else
      @message_post = @message
      @user = current_user
      @messages = @room.messages
      render 'rooms/show'
    end
  end

  def destroy
  end

  private
    def set_room
      @room = current_user.rooms.find(params[:room_id])
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
