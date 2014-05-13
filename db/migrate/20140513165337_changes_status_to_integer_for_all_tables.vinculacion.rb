# This migration comes from vinculacion (originally 20140513154758)
class ChangesStatusToIntegerForAllTables < ActiveRecord::Migration
  def change

    # MySql no soporta el cambio de tipo en automatico

    remove_column :vinculacion_solicitudes, :status
    remove_column :vinculacion_muestras, :status
    remove_column :vinculacion_servicios, :status
    remove_column :vinculacion_proyectos, :status
    remove_column :vinculacion_cotizaciones, :status

    add_column :vinculacion_solicitudes, :status, :integer, :default => 1
    add_column :vinculacion_muestras, :status, :integer, :default => 1
    add_column :vinculacion_servicios, :status, :integer, :default => 1
    add_column :vinculacion_proyectos, :status, :integer, :default => 1
    add_column :vinculacion_cotizaciones, :status, :integer, :default => 1

  end
end

