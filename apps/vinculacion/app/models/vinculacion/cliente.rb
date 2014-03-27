module Vinculacion
  class Cliente < ActiveRecord::Base
    has_many :contactos
  end
end
