class AddRoleToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :role, :string
  end
end
