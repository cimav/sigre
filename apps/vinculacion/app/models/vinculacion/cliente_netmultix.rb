module Vinculacion
  class ClienteNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = "cl01"
  end
end