class AddStatusToRegistro < ActiveRecord::Migration
  def change
    add_column :vinculacion_registros, :status, :integer, :default => 0
  end
end
