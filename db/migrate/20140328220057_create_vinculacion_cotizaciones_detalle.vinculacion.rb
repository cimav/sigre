# This migration comes from vinculacion (originally 20140328204210)
class CreateVinculacionCotizacionesDetalle < ActiveRecord::Migration
  def change
    create_table :vinculacion_cotizaciones_detalle do |t|
      t.integer :cantidad, :default => 1
      t.string :concepto
      t.decimal    :precio_unitario, :precision => 10, :scale => 2, :default => 0.00
      t.integer :status, :default => 0

      t.references :cotizacion

      t.timestamps
    end
  end
end


