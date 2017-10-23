module RoomsHelper
  def room_participants(user, i)
    i == 0 ? user.name : "/ " + user.name
  end

  def read_user_count(users, room, message)
    if message.user == current_user then
      unless users.count == 1 && users.first == current_user then
        read_count = 0
        users.each do |user|
          latest_read_message_id = user.user_rooms
                                       .find_by(room: room)
                                       .latest_read_message_id
          if user != current_user && !latest_read_message_id.nil? then
            if message.id <= latest_read_message_id then
              read_count += 1
            end
          end
        end
        if read_count == 0 then
          "Unread"
        else
          "Read:#{read_count}"
        end
     end
    end
  end

  def read_state(room)
    latest_read_message_id = current_user.user_rooms
                                         .find_by(room: room)
                                         .latest_read_message_id
    room_latest_message_id = room.messages.order(id: "DESC")
                                          .first.id
    unless room.messages.count == 0 || latest_read_message_id.nil? then
      "--unread" if room_latest_message_id > latest_read_message_id
    end
  end

  def last_read_msg_id(room)
    msg_id = room.user_rooms.find_by(user: current_user).latest_read_message_id
    msg_id == 0 ? room.messages.order(id: "ASC").first : msg_id
  end
end
