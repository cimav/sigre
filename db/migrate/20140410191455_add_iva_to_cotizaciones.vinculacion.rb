# This migration comes from vinculacion (originally 20140410191403)
class AddIvaToCotizaciones < ActiveRecord::Migration
  def change
    add_column :vinculacion_cotizaciones, :iva, :decimal, :precision => 10, :scale => 2, :default => 15.00
  end
end
