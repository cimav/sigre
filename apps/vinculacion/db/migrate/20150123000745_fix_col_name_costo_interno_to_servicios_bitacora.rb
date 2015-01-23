class FixColNameCostoInternoToServiciosBitacora < ActiveRecord::Migration
  def change
    rename_column :vinculacion_servicios_bitacora, :precio_interno, :costo_interno
  end
end
