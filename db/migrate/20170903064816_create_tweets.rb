class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.string :tweet_text, limit: 140
      t.string :image
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :tweets, [:user_id, :created_at]
  end
end
