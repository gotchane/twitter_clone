class TweetsController < ApplicationController
  def new
    @tweet = current_user.tweets.new
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      redirect_to current_user, success: "Tweet succeeded!"
    else
      @user = current_user
      @tweet_post = @tweet
      @tweets = Tweet.current_user_feeds(current_user).paginate(page: params[:page])
      render 'users/show'
    end
  end

  def destroy
    @tweet = current_user.tweets.find_by(id: params[:id])
    @tweet.destroy
    redirect_to request.referrer, success: "Tweet deleted successfully!"
  end

  private
    def tweet_params
      params.require(:tweet).permit(:tweet_text,:image)
    end
end
