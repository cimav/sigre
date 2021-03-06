module Vinculacion
  class Cliente < ActiveRecord::Base
    has_many :contactos, :dependent => :delete_all
    belongs_to :pais
    belongs_to :estado
    has_many :solicitudes
  end
end
