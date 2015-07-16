class CreateVinculacionMuestrasDetalle < ActiveRecord::Migration
  def change
    create_table :vinculacion_muestras_detalle do |t|
      t.references :muestras
      t.integer    :consecutivo
      t.string     :cliente_identificacion
      t.text       :notas
      t.string     :status, :default => 1
    end
  end
end
