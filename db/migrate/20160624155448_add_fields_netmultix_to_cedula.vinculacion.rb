# This migration comes from vinculacion (originally 20160624154912)
class AddFieldsNetmultixToCedula < ActiveRecord::Migration
  def change

    add_column :vinculacion_cedulas, :cedula_netmultix, :string
    add_column :vinculacion_cedulas, :cliente_netmultix_id, :integer
    add_column :vinculacion_cedulas, :proyecto_id, :integer
    add_column :vinculacion_cedulas, :sub_proyecto, :string
    add_column :vinculacion_cedulas, :concepto_en_extenso, :string
    add_column :vinculacion_cedulas, :observaciones, :string
    add_column :vinculacion_cedulas, :usr_transmite_id, :integer
    add_column :vinculacion_cedulas, :transmitida_at, :datetime
    add_column :vinculacion_cedulas, :usr_envia_id, :integer
    add_column :vinculacion_cedulas, :enviada_at, :datetime

  end
end
