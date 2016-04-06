module Vinculacion
  class ContactoNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = "cl06"
    self.primary_key = 'cl06_clave'

    belongs_to :cliente_netmultix, foreign_key: :cl06_clave, primary_key: :cl01_clave

  end
end