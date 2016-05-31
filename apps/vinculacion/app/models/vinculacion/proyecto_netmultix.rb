module Vinculacion
  class ProyectoNetmultix < ActiveRecord::Base
    establish_connection "#{Rails.env}_netmultix"

    self.table_name = 'pr13'

=begin
    attr_accessor :id
    def id
      self.ft16_cedula.tr('/','').to_i
    end
=end

  end
end