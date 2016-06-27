module Vinculacion
  class CostoVariableNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = 'ft17'

  end
end