module Vinculacion
  class ClienteSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :rfc, :razon_social, :num_empleados, :calle_num, :colonia, :cp, :telefono, :fax, :email, :tamano_empresa, :sector
    has_many :contactos
  end
end
