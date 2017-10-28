class RoomsController < ApplicationController
  before_action :set_room, only:[:show, :destroy, :mark_read]
  before_action :set_user_room, only:[:show, :mark_read]

  def index
    @rooms = current_user.rooms.check_available.sort_by_message_created
  end

  def show
    @messages = @room.messages.after_history_deletion(@user_room.datetime_last_history_deleted)
                              .order(created_at: :desc)
    @message_post = current_user.messages.new
  end

  def new
    @users = User.all
    @room = current_user.rooms.new
    @user_rooms = @room.user_rooms.new
  end

  def create
    if user_room_params.nil?
      redirect_to new_user_room_path(current_user), danger: "Please select at least one user."
    elsif check_dup_room?(user_room_params)
      redirect_to new_user_room_path(current_user), danger: "Participant combination is overlapped."
    else
      @room = current_user.rooms.build(create_user_id: current_user.id)
      current_user.save!
      user_room_params.each do |param|
        @room.user_rooms.create(user_id: param)
      end
      redirect_to user_room_path(current_user, @room)
    end
  end

  def mark_read
    @message = @room.messages.order(created_at: :desc).first
    @user_room.mark_last_read_message(@message)
    render json: {status: "OK", code: 200}
  end

  def destroy
    @room.delete_messages_history(current_user)
    redirect_to user_rooms_path(current_user), success: "Messages history deleted successfully!"
  end

  private
    def set_room
      @room = current_user.rooms.check_available.find(params[:id])
    end

    def set_user_room
      @user_room = @room.user_rooms.find_by(user: current_user)
    end

    def user_room_params
      params[:room].require(:user_room).permit(user_id: [])[:user_id] unless params[:room].nil?
    end

    def check_dup_room?(user_room_params)
      check_flag = false
      current_user.rooms.check_available.each do |room|
        match_array = user_room_params.map(&:to_i)
        match_array << current_user.id unless match_array.include?(current_user.id)
        if match_array.sort == room.users.ids.sort
          check_flag = true
        end
      end
      check_flag
    end
end
