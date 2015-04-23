# This migration comes from vinculacion (originally 20150423211754)
class ChangesConceptoToTextInCotizacionesDetalle < ActiveRecord::Migration
  def change
    change_column :vinculacion_cotizaciones_detalle, :concepto, :text
  end
end
