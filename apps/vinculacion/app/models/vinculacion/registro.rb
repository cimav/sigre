module Vinculacion
  class Registro < ActiveRecord::Base
    belongs_to :usuario
    belongs_to :solicitud
  end
end
