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
      render @user
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
      params.require(:tweet).permit(:tweet_text,:user_id)
    end
end
