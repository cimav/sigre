module Vinculacion
  class Usuario < ActiveRecord::Base

    STATUS_ACTIVO = 1
    STATUS_SUSPENDIDO = 2

    self.table_name = "usuarios"

  end
end