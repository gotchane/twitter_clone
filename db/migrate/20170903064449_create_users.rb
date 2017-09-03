class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :encrypted_password
      t.string :about

      t.timestamps
    end
  end
end
