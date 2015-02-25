class AddSedeToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :sede_id, :integer
  end
end
