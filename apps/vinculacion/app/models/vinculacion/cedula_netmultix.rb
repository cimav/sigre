module Vinculacion
  class CedulaNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = 'ft16'

    attr_accessor :id
    def id
      self.ft16_cedula.tr('/','').to_i
    end

  end
end
