class UsuarioSerializer < ActiveModel::Serializer
  embed :ids, :include => true
  attributes :id, :usuario, :email, :nombre, :apellidos, :status, :role
end
