class StaticPagesController < ApplicationController
  skip_before_action :logged_in_user, only: [:home]
  before_action :redirect_if_logged_in, only: [:home]

  def home
  end

  private
    def redirect_if_logged_in
      redirect_to current_user if logged_in?
    end
end
