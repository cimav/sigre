module Vinculacion
  class RegistroSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id
    attributes :tipo, :mensaje, :status, :status_text, :created_at
    #has_one :solicitud
    attributes :solicitud_id
    has_one :empleado
    has_many :registro_notas
  end
end