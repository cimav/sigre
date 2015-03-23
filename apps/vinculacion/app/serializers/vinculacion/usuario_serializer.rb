module Vinculacion
  class UsuarioSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id, :usuario, :email, :nombre, :apellidos, :status, :role, :sede_id, :proyecto_id

  end
end