# This migration comes from vinculacion (originally 20140519184447)
class AddOrdenCompraAndFechasToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :orden_compra, :string
    add_column :vinculacion_solicitudes, :fecha_inicio, :date
    add_column :vinculacion_solicitudes, :fecha_termino, :date
  end
end
