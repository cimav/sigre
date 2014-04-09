class AddColumnsForStatusToCotizaciones < ActiveRecord::Migration
  def change
    add_column :vinculacion_cotizaciones, :msg_notificacion, :text
    add_column :vinculacion_cotizaciones, :motivo_status, :text
  end
end

