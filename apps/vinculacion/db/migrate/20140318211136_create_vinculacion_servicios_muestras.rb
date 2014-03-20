class CreateVinculacionServiciosMuestras < ActiveRecord::Migration
  def change
    create_table :vinculacion_servicios_muestras, id: false do |t|
      t.belongs_to :servicio
      t.belongs_to :muestra
      t.timestamps
    end
  end
end
