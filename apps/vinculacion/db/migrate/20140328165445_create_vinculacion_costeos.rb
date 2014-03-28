class CreateVinculacionCosteos < ActiveRecord::Migration
  def change
    create_table :vinculacion_costeos do |t|
      t.integer    :consecutivo
      t.string     :codigo, :limit => 20
      t.references :servicio
      t.references :usuario
      t.integer    :status, :default => 1 
      t.timestamps
    end
  end
end
