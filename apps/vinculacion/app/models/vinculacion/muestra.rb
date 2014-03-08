module Vinculacion
  class Muestra < ActiveRecord::Base
  	belongs_to :solicitud
  end
end
