class AddPrecioSugeridoToServicios < ActiveRecord::Migration
  def change
    add_column :vinculacion_servicios, :precio_sugerido, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end
end
