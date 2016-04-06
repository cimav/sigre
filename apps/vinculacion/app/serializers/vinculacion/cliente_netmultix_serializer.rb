module Vinculacion
  class ClienteNetmultixSerializer < ActiveModel::Serializer
    attributes :id, :cl01_clave, :cl01_nombre, :cl01_rfc
    has_many :contactos_netmultix
  end
end


