module Proyectos
  class Fondo < ActiveRecord::Base
    belongs_to :recurso
  end
end
