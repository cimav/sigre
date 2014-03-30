module Vinculacion
  class CosteoDetalle < ActiveRecord::Base
    belongs_to :costeo
  end
end
