module Vinculacion
  class ClienteNetmultixSerializer < ActiveModel::Serializer
    attributes :id, :cl01_clave, :cl01_nombre, :cl01_rfc, :cl01_lada, :cl01_telefono1, :cl01_tipo_cliente, :cl01_tipo_empresa, :cl01_empleados
    has_many :contactos_netmultix
  end
end


