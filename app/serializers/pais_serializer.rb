class PaisSerializer < ActiveModel::Serializer
  embed :ids, :include => true
  attributes :id,:nombre
end
