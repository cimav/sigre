module Vinculacion
  class ProyectoSerializer < ActiveModel::Serializer
    embed :ids , :include => true
    attributes :id
    attributes :cuenta, :nombre, :descripcion
    #has_many  :solicitudes # evita tener una mega-estructura
  end
end
