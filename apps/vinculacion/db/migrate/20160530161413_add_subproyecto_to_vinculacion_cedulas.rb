class AddSubproyectoToVinculacionCedulas < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedulas, :sub_proyecto, :string
  end
end
