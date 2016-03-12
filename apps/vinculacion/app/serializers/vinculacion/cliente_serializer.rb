module Vinculacion
  class ClienteSerializer < ActiveModel::Serializer
    # embed :ids
    attributes :id
    attributes :rfc, :razon_social, :num_empleados, :calle_num, :colonia, :cp, :telefono, :fax, :email, :tamano_empresa, :sector, :estado_id,:ciudad
    has_many :contactos
    has_one :pais
    has_one :estado
  end
end
