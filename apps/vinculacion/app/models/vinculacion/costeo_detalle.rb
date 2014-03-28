module Vinculacion
  class CosteoDetalle < ActiveRecord::Base
    belongs_to :costeo
    belongs_to :muestra
  end
end
