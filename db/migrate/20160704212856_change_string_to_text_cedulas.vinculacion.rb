# This migration comes from vinculacion (originally 20160704212453)
class ChangeStringToTextCedulas < ActiveRecord::Migration
  def change
    change_column :vinculacion_cedulas, :concepto_en_extenso, :text
    change_column :vinculacion_cedulas, :observaciones, :text
  end
end
