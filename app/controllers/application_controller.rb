class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :info, :warning, :danger
  before_action :logged_in_user
  include SessionsHelper
  include UsersHelper

  def logged_in_user
    unless logged_in?
      redirect_to login_url, danger: "Please log in."
    end
  end
end
