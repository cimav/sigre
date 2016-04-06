module Vinculacion
  class ContactoNetmultixSerializer < ActiveModel::Serializer
    attributes :cl06_clave, :cl06_contacto, :cl06_email
    has_one :cliente_netmultix
  end
end