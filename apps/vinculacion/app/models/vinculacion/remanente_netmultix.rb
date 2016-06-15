module Vinculacion
  class RemanenteNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = 'ft18'

  end
end