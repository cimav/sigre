module Proyectos
  class Recurso < ActiveRecord::Base
    belongs_to :tipo
  end
end
