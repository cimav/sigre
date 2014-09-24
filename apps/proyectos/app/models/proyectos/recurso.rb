module Proyectos
  class Recurso < ActiveRecord::Base
    belongs_to :tipo
    has_many :fondos
  end
end
