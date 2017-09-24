class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :following, :followers]

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
    @user = User.find(params[:id])
    @avater_url = @user.avater? ? @user.avater.url : "app/assets/images/sample-user.png"
    @tweet_post = @user.tweets.new
    if @user == current_user
      @tweets = Tweet.where("user_id IN (?) OR user_id = ?", @user.following_ids, @user.id).paginate(page: params[:page])
    else
      @tweets = @user.tweets.paginate(page: params[:page])
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash.now[:success] = "Updating user profile succeeded!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @user = User.find(params[:id])
    @users = User.find(params[:id]).following
    @title = "Following"
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @avater_url = @user.avater? ? @user.avater.url : "app/assets/images/sample-user.png"
    @users = User.find(params[:id]).followers
    @title = "Followed"
    render 'show_follow'
  end

  private
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
