# This migration comes from vinculacion (originally 20150309193727)
class CreateVinculacionLaboratoriosBitacora < ActiveRecord::Migration
  def change
    create_table :vinculacion_laboratorios_bitacora do |t|
      t.integer :id_lab_bitacora
      t.string  :nombre
    end
  end
end
