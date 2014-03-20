module Vinculacion
  class ServiciosMuestrasSerializer < ActiveModel::Serializer
  	embed :ids 
    attributes :id
    belongs_to :servicio
    belongs_to :muestra
  end
end