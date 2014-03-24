module Vinculacion
  class ContactoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :nombre, :telefono, :email
    #attributes :cliente_id
    #belongs_to :cliente
    has_one :cliente
  end
end

