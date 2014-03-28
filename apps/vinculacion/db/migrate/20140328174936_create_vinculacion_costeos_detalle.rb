class CreateVinculacionCosteosDetalle < ActiveRecord::Migration
  def change
    create_table :vinculacion_costeos_detalle do |t|
      t.references :costeo
      t.references :muestra
      t.integer    :tipo
      t.string     :descripcion
      t.integer    :cantidad
      t.decimal    :precio_unitario, :precision => 10, :scale => 2
      t.integer    :status, :default => 1 
      t.timestamps
    end
  end
end
