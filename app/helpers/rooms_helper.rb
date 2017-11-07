module RoomsHelper
  def room_participants(users)
    users.map(&:name).join(" / ")
  end

  def message_read_count(message)
    read_count = message.read_count(current_user)
    read_count == 0 ? "Unread" : "Read:#{read_count}"
  end

  def read_state(room)
    "--unread" if room.has_unread_message?(current_user)
  end
end
