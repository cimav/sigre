class AddProyectoToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :proyecto_id, :integer
  end
end
