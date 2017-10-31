module RoomsHelper
  def room_participants(users)
    users.map(&:name).join(" / ")
  end

  def message_read_count(message)
    if message.user == current_user
      read_count = 0
      latest_read_message_ids = message.room.user_rooms
                                            .where.not(user_id: current_user.id)
                                            .map(&:latest_read_message_id)
      latest_read_message_ids.each do |latest_read_message_id|
        read_count += 1 if message.id <= latest_read_message_id
      end
      read_count == 0 ? "Unread" : "Read:#{read_count}"
    end
  end

  def read_state(room)
    latest_read_message_id = current_user.user_rooms
                                         .find_by(room: room)
                                         .latest_read_message_id
    room_latest_message_id = room.messages.order(id: :desc)
                                          .first.id unless room.messages.count == 0
    if room.messages.count != 0 && !latest_read_message_id.nil? && !room_latest_message_id.nil?
      "--unread" if room_latest_message_id > latest_read_message_id
    end
  end

  def last_read_msg_id(room)
    msg_id = room.user_rooms.find_by(user: current_user).latest_read_message_id
    if msg_id == 0 && room.messages.count != 0
      room.messages.order(id: :asc).first.id
    else
      msg_id
    end
  end
end
