# coding: utf-8
module Vinculacion
  class CostoVariable < ActiveRecord::Base

    self.table_name = "vinculacion_costos_variables"

    belongs_to :servicio

  end

end

