module ApplicationHelper
  def logo_url
    logged_in? ? user_path(current_user) : root_path
  end
end
