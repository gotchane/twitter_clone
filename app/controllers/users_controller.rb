class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :following, :followers]
  before_action :set_user,       only: [:show, :edit, :update, :following, :followers]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash.now[:success] = "Welcome to the Twitter clone!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @tweet_post = @user.tweets.new
    if @user == current_user
      @tweets = Tweet.current_user_feeds(@user).paginate(page: params[:page])
    else
      @tweets = @user.tweets.paginate(page: params[:page])
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash.now[:success] = "Updating user profile succeeded!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @users = @user.following
    @title = "Following"
    render 'show_follow'
  end

  def followers
    @users = @user.followers
    @title = "Followed"
    render 'show_follow'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avater, :profile)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
