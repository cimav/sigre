module Vinculacion
  class Empleado < ActiveRecord::Base

    self.table_name = "rh_empleados"

    #belongs_to :departamento
    #belongs_to :sede

    def nombre_completo
      "#{nombre} #{apellido_paterno} #{apellido_materno}"
    end

    def avatar_url
      username = email.split(/@/)[0]
      "http://cimav.edu.mx/foto/#{username}/64"
    end

  end
end
