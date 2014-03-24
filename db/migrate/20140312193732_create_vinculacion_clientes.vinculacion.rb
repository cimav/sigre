# This migration comes from vinculacion (originally 20140312184259)
class CreateVinculacionClientes < ActiveRecord::Migration
  def change
    create_table :vinculacion_clientes do |t|
      t.string    :rfc
      t.string    :razon_social
      t.integer   :num_empleados
      t.string    :calle_num
      t.string    :colonia
      t.string    :cp
      t.string    :telefono
      t.string    :fax
      t.string    :email

      t.timestamps
    end
  end
end
