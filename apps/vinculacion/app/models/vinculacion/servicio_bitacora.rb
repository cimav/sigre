module Vinculacion
  class ServicioBitacora < ActiveRecord::Base
  	after_initialize do |s|
      s.nombre = ActionController::Base.helpers.strip_tags(s.nombre) 
      s.descripcion = ActionController::Base.helpers.strip_tags(s.descripcion) 
    end
  end
end
