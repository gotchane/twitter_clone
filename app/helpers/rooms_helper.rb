module RoomsHelper
  def room_participants(user, i)
    i == 0 ? user.name : "/ " + user.name
  end
end
