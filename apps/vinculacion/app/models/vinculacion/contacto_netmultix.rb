module Vinculacion
  class ContactoNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = "cl06"

  end
end