# This migration comes from vinculacion (originally 20140410162702)
class AddDuracionToCotizaciones < ActiveRecord::Migration
  def change
    add_column :vinculacion_cotizaciones, :duracion, :integer
  end
end
