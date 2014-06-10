class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |table|
      table.integer :user_id, null: false
      table.integer :event_id, null: false
      table.string :title
      table.string :body, null: false

      table.timestamps
    end
  end
end
