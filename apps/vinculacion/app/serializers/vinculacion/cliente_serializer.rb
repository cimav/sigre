module Vinculacion
  class ClienteSerializer < ActiveModel::Serializer
    attributes :id, :rfc, :nombre
  end
end
