class AddResponsablePresupuestalToSolicitudes < ActiveRecord::Migration
  def change
    add_reference :vinculacion_solicitudes, :responsable_presupuestal_id, references: :empleados;
  end
end
