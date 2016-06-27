module Rh
  class Empleado < ActiveRecord::Base

    belongs_to :departamento
    belongs_to :sede

  	def nombre_completo
      "#{nombre} #{apellido_paterno} #{apellido_materno}"
  	end

  end
end
