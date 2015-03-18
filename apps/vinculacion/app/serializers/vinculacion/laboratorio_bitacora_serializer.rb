module Vinculacion
  class LaboratorioBitacoraSerializer < ActiveModel::Serializer
    #embed :ids, :include => true
    attributes :id
    attributes :id_lab_bitacora
    attributes :nombre
  end
end
