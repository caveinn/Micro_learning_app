class CreateTutorials < ActiveRecord::Migration[5.2]
  def change
    create_table :tutorials do |t|
      t.string :title, null: false,unique: true
      t.string :topic, null:false, unique: true
      t.text :content,null:false
      t.belongs_to :user, index: true
      end
  end
end
