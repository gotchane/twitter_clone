class MessagesController < ApplicationController
  before_action :set_room

  def new
    @message = @room.messages.new(user: current_user)
  end

  def create
    @message = @room.messages.build(message_params)
    @message.user = @message.current_user = current_user
    if @message.save
      redirect_to user_room_path(current_user,@room), success: "Post message succeeded!"
    else
      @message_post = @message
      @user = current_user
      @messages = @room.messages
      render template: 'rooms/show'
    end
  end

  def destroy
    @message = @room.messages.find_by(id: params[:id], user: current_user)
    @message.destroy
    redirect_to request.referrer, success: "Message deleted successfully!"
  end

  def mark_read
    @message = @room.messages.order(created_at: :desc).first
    @message.current_user = current_user
    @message.mark_last_read_message
    render json: {status: "OK", code: 200}
  end

  private
    def set_room
      @room = current_user.rooms.find(params[:room_id])
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
