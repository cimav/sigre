# This migration comes from vinculacion (originally 20160405231508)
class AddStatusToRegistro < ActiveRecord::Migration
  def change
    add_column :vinculacion_registros, :status, :integer, :default => 0
  end
end
