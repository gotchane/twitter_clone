class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :following, :followers]

  def index
    @users = User.all
    @user_type = "All"
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
    @tweets = @user.tweets.paginate(page: params[:page])
    @tweet_post = @user.tweets.new
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
    @users = User.find(params[:id]).followers
    @title = "Followed"
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
