module Vinculacion
  class ClienteNetmultix < CimavNetmultixRecord
    # establish_connection "#{Rails.env}_netmultix"

    self.table_name = "netmultix.cl01"
    self.primary_key = 'cl01_clave'

    attr_accessor :id
    def id
      self.cl01_clave.to_i
    end

    # has_many :contactos_netmultix, -> { where("cl06_clave = ?", self.cl01_clave)},  :class_name => 'ContactoNetMultix'
    has_many :contactos_netmultix, foreign_key: :cl06_clave, primary_key: :cl01_clave

    attr_accessor :telefono
    def telefono
      lada = self.cl01_lada.delete('(').delete('(').delete(' ')
      lada = lada.length == 0 ? '' : '(' + lada + ')'
      telefono = lada + self.cl01_telefono1
    end

  end
end