class ChangeDatatypeImportantOfTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :important
    add_column :tasks, :important,:integer, default: 3 , null: false
  end
end
