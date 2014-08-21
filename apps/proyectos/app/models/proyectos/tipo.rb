module Proyectos
  class Tipo < ActiveRecord::Base
    has_many :recursos
  end
end
