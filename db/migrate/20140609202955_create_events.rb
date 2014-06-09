class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |table|
      # table.integer :created_by, null: false
      table.string :name, null: false
      table.string :location, null: false
      # table.date :time, null: false
      table.string :description, null: false

      table.timestamps
    end
  end
end
