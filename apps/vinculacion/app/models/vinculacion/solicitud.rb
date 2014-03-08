module Vinculacion
  class Solicitud < ActiveRecord::Base
  	has_many :muestras
  end
end
