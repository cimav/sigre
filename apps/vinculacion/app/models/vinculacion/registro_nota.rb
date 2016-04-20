module Vinculacion
  class RegistroNota < ActiveRecord::Base
    belongs_to :registro
  end
end
