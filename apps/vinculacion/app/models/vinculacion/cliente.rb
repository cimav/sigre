module Vinculacion
  class Cliente < ActiveRecord::Base
    has_many :contactos, :dependent => :delete_all
  end
end
