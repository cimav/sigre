class AddDuracionToCotizaciones < ActiveRecord::Migration
  def change
    add_column :vinculacion_cotizaciones, :duracion, :integer
  end
end
