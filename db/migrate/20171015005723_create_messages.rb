class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body, null:false
      t.references :room, foreign_key: true
      t.integer :user_id, null:false

      t.timestamps
    end
  end
end
