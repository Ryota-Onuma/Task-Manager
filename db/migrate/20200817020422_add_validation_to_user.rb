class AddValidationToUser < ActiveRecord::Migration[6.0]
  def up  # change_columnは、def changeではなく、　def up にしないと、ロールバック時にエラーが出るとのことなので
    change_column :users, :name, :string, limit: 20, null: false
    change_column :users, :email, :string, limit: 50, null: false, unique: true
    change_column :users, :password_digest, :string, null: false
    change_column :users, :introduction, :text, limit: 150
    change_column :users, :permission, :boolean, default: false, null: false
    change_column :users, :admin, :boolean, default: false, null: false
  end
end