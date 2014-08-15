# This migration comes from vinculacion (originally 20140815172210)
class AddResponsablePresupuestalToSolicitudes < ActiveRecord::Migration
  def change
    add_reference :vinculacion_solicitudes, :responsable_presupuestal, references: :empleados;
  end
end
