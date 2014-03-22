class CreateVinculacionSectoresIndustrial < ActiveRecord::Migration
  def change
    create_table :vinculacion_sectores_industrial do |t|
      t.string     :codigo, :limit => 20
      t.text       :descripcion
      t.timestamps
    end
  end
end
