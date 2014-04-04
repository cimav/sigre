class FixCondicionIdiomaDivisaToCotizacion < ActiveRecord::Migration
  def change
    rename_column :vinculacion_cotizaciones, :condicion_pago_id, :condicion
    rename_column :vinculacion_cotizaciones, :idioma_id, :idioma
    rename_column :vinculacion_cotizaciones, :divisa_id, :divisa
  end
end
