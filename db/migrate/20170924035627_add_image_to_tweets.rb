class AddImageToTweets < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :image, :string
  end
end
