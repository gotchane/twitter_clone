class UsersController < ApplicationController
  skip_before_action :logged_in_user, only: [:new, :create]
  before_action :set_user,       only: [:show, :edit, :update, :following, :followers, :follow, :unfollow]

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
      redirect_to @user, success: "Welcome to the Twitter clone!"
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
      redirect_to @user, success: "Updating user profile succeeded!"
    else
      render 'edit'
    end
  end

  def following
    @users = @user.following
  end

  def followers
    @users = @user.followers
  end

  def follow
    current_user.follow(@user)
    redirect_to @user
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_to @user
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avater, :profile)
    end
end
