class StaticPagesController < ApplicationController
  skip_before_action :logged_in_user, only: [:home]
  before_action :root_after_login, only: [:home]

  def home
  end

  private
    def root_after_login
      redirect_to current_user if logged_in?
    end
end
