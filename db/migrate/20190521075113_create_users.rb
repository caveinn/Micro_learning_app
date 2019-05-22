class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name, null: false, unique: true
      t.string :role, null: false
      t.string :interests
      t.text :password, null: false
      t.text :email, null: false, unique: true
      end
  end

end
