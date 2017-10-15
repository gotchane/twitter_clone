class CreateUserRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :user_rooms do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.integer :latest_read_message_id
      t.timestamp :last_history_deleted
      t.boolean :available_flag, default:true

      t.timestamps
    end
  end
end
