module Vinculacion
  class ApplicationSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
  end
end
