module Vinculacion
  class ClienteSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :rfc, :razon_social
    has_many :contactos
  end
end
