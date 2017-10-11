module UsersHelper
  def avater_url(user)
    user.avater? ? user.avater.url : "no-image.jpg"
  end

  def avater_image(user)
    image_tag avater_url(user), class: 'avater_image'
  end
end
