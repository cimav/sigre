# This migration comes from vinculacion (originally 20140312184259)
class CreateVinculacionClientes < ActiveRecord::Migration
  def change
    create_table :vinculacion_clientes do |t|
      t.string :rfc
      t.string :nombre

      t.timestamps
    end
  end
end
