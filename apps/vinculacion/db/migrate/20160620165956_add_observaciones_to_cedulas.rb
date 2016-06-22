class AddObservacionesToCedulas < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedulas, :observaciones, :string
  end
end

