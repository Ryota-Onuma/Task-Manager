class AddColumnTokenToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :token, :string
    add_index :users, :token, unique: true
  end

  def down
    remove_column :users, :token, :string
    remove_index :users, :token, unique: true
  end
end
