class AddValidationToTask < ActiveRecord::Migration[6.0]
  def up   # change_columnは、def changeではなく、　def up にしないと、ロールバック時にエラーが出るとのことなので
    change_column :tasks, :title, :string, limit: 30, null: false
    change_column :tasks, :content, :text, default: "タスクの内容はまだ決まっていません。", null: false
    change_column :tasks, :status, :integer, default: 1 , null: false
    remove_column :tasks, :important
    add_column :tasks, :important, :integer, default: 3 , null: false
  end
end
