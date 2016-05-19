class AddNetmultixToCedula < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedulas, :cedula_netmultix, :string
    add_column :vinculacion_cedulas, :cliente_netmultix_id, :integer
    add_column :vinculacion_cedulas, :concepto_en_extenso, :string
  end
end
