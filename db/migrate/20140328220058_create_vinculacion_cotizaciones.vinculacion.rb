# This migration comes from vinculacion (originally 20140328204814)
class CreateVinculacionCotizaciones < ActiveRecord::Migration
  def change
    create_table :vinculacion_cotizaciones do |t|
      t.string :consecutivo
      t.date :fecha_notificacion
      t.integer :condicion_pago_id
      t.integer :idioma_id
      t.integer :divisa_id
      t.text :comentarios
      t.text :observaciones
      t.text :notas
      t.decimal    :subtotal, :precision => 10, :scale => 2, :default => 0.00
      t.decimal    :precio_venta, :precision => 10, :scale => 2, :default => 0.00
      t.decimal    :precio_unitario, :precision => 10, :scale => 2, :default => 0.00
      t.decimal    :descuento_porcentaje, :precision => 5, :scale => 2, :default => 0.00
      t.integer :descuento_status, :default => 0
      t.integer :status, :default => 0

      t.references :solicitud

      t.timestamps
    end
  end
end
