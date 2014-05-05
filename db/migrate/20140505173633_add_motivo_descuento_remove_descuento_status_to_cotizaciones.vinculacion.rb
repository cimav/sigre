# This migration comes from vinculacion (originally 20140505173225)
class AddMotivoDescuentoRemoveDescuentoStatusToCotizaciones < ActiveRecord::Migration
  def change
    add_column :vinculacion_cotizaciones, :motivo_descuento, :text
    remove_column :vinculacion_cotizaciones, :descuento_status
  end
end
