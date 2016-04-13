module Vinculacion
  class PaisNetmultixSerializer < ActiveModel::Serializer
    attributes :id, :cl12_pais, :cl12_nombre
  end
end
