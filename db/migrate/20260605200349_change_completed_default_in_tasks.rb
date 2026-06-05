class ChangeCompletedDefaultInTasks < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tasks, :completed, false
    # Также обновляем существующие NULL значения
    Task.where(completed: nil).update_all(completed: false)
  end
end