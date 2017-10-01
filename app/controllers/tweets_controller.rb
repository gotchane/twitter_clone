class TweetsController < ApplicationController
  def new
    @user = User.find(params[:id])
    @tweet = @user.tweets.new
  end

  def create
    @user = User.find(tweet_params[:user_id])
    @tweet = @user.tweets.build(tweet_params)
    if @tweet.save
      flash[:success] = "Tweet succeeded!"
      redirect_to @user
    else
      @tweet_post = @tweet
      @tweets = Tweet.current_user_feeds(@user).paginate(page: params[:page])
      render 'users/show'
    end
  end

  def destroy
    @tweet = Tweet.find_by(id: params[:id])
    @tweet.destroy
    flash[:success] = "Tweet deleted successfully!"
    redirect_to request.referrer
  end

  private
    def tweet_params
      params.require(:tweet).permit(:tweet_text,:user_id,:image)
    end
end
