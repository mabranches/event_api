class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.date :start
      t.date :end
      t.integer :number_of_days
      t.string :location
      t.boolean :published, default: false
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
  end
end
