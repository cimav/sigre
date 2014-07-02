class CreateVinculacionRemanentes < ActiveRecord::Migration
  def change
    create_table :vinculacion_remanentes do |t|
      t.references :servicio
      t.references :empleado
      t.decimal :porcentaje_participacion, :precision => 6, :scale => 2, :default => 0.00
      t.decimal :monto, :precision => 10, :scale => 2, :default => 0.00
      t.timestamps
    end
  end
end
