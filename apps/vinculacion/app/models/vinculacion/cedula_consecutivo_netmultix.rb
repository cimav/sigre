module Vinculacion
  class CedulaConsecutivoNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = 'ft61'

  end
end