module Vinculacion
  class RegistroNotaSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id
    attributes :mensaje, :created_at, :usuario_id, :registro_id
    # has_one :usuario
  end
end