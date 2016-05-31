# This migration comes from vinculacion (originally 20160530161413)
class AddSubproyectoToVinculacionCedulas < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedulas, :sub_proyecto, :string
  end
end
