# This migration comes from vinculacion (originally 20150327191657)
class AddTiempoEntregaToCotizaciones < ActiveRecord::Migration
  def change
    add_column :vinculacion_cotizaciones, :tiempo_entrega, :integer, :default => 1
  end
end
