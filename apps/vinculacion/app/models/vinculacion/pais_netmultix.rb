module Vinculacion
  class PaisNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = "cl12"
    self.primary_key = 'cl12_pais'

    attr_accessor :id
    def id
      self.cl12_pais
    end

  end
end
