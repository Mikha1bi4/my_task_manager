class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.boolean :completed
      t.date :due_date
      t.integer :priority

      t.timestamps
    end
  end
end
