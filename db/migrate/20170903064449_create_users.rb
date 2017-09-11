class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email,               null: false
      t.string :password_digest,     null: false
      t.string :remember_token
      t.string :about
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
      t.timestamps
    end
  end
end
