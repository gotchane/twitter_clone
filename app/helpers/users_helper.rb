module UsersHelper
  def avater_url(user)
    return user.avater? ? user.avater.url : "no-image.jpg"
  end
end
