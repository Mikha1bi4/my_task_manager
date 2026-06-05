class ChangePriorityToString < ActiveRecord::Migration[7.0]
  def change
    change_column :tasks, :priority, :string, default: 'medium'
  end
end