module Vinculacion
  class ContactoNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = "cl06"
    self.primary_key = 'cl06_clave'

    attr_accessor :id

    def id # getter
      @id
    end

    def id=(value) #  setter
      s = self.cl06_clave + value.to_s
      @id = s.delete(' ').to_i
    end

    #belongs_to :cliente_netmultix, foreign_key: :cl01_clave, primary_key: :cl06_clave

  end
end
