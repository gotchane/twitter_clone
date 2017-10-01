module UsersHelper
  def avater_url(user)
    user.avater? ? user.avater.url : "no-image.jpg"
  end
end
