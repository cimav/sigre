module Vinculacion
  class ClienteNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = "cl01"

    attr_accessor :id
    def id
      self.cl01_clave.to_i
    end

  end
end