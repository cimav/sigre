module Vinculacion
  class ClienteNetmultixSerializer < ActiveModel::Serializer
    attributes :cl01_clave, :cl01_nombre, :cl01_rfc
  end
end