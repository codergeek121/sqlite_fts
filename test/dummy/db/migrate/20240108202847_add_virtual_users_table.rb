class AddVirtualUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_virtual_fts_table(:users, :name, :lastname)
  end
end
