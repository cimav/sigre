class AddInmutableAndServicioIdToCotizacionesDetalle < ActiveRecord::Migration
  def change
    add_column :vinculacion_cotizaciones_detalle, :inmutable, :boolean, :default => false
    add_column :vinculacion_cotizaciones_detalle, :servicio_id, :integer
  end
end
