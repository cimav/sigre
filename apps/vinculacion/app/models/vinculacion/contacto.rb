module Vinculacion
  class Contacto < ActiveRecord::Base
    belongs_to :cliente
  end
end
