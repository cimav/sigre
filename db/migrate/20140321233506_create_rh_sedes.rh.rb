# This migration comes from rh (originally 20140304165252)
class CreateRhSedes < ActiveRecord::Migration
  def change
    create_table :rh_sedes do |t|
      t.string     :nombre,             :null => false
      t.string     :descripcion,        :null => false
      t.references :empleado
      t.timestamps
    end
  end
end
