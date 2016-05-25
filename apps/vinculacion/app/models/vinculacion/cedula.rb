# coding: utf-8
module Vinculacion
  class Cedula < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :servicio
    has_many :costo_variable
    has_many :remanentes

    after_update :check_status_for_transmitir

    attr_accessor :total_costo_variable
    attr_accessor :costo_indirecto
    attr_accessor :costo_interno
    attr_accessor :porcentaje_participacion
    attr_accessor :utilidad
    attr_accessor :precio_venta
    attr_accessor :remanente_distribuible

    INICIAL       = 1
    TRANSMITIENDO = 2
    TRANSMITIDA   = 3
    CANCELADO     = 99

    STATUS = {
        INICIAL       => 'Inicio',
        TRANSMITIENDO => 'Transmitiendo...',
        TRANSMITIDA   => 'Transmitida',
        CANCELADO     => 'Cancelada'
    }

    def total_costo_variable
      self.costo_variable.sum('costo')
    end

    def costo_indirecto
      self.total_costo_variable * 0.1726
    end

    def costo_interno
      self.total_costo_variable + self.costo_indirecto
    end

    def porcentaje_participacion
      self.costo_interno * 100 / self.solicitud.costo_interno
    end

    def precio_venta
      self.porcentaje_participacion * self.solicitud.precio_venta / 100
    end

    def utilidad_neta
      self.precio_venta - self.costo_interno
    end

    def utilidad_topada
      tope = 70 * self.precio_venta / 100
      self.utilidad_neta > tope ? tope : self.utilidad_neta
    end

    def remanente_distribuible
      self.utilidad_topada * 0.35
    end

    def check_status_for_transmitir
      if self.status_changed? && self.status == TRANSMITIENDO
          self.status = TRANSMITIDA

          cve_cliente_netmultix = self.cliente_netmultix_id.to_s.rjust(5,'0') rescue 'no-cve'
          cliente_netmultix = ClienteNetmultix.where("cl01_clave LIKE '%" + cve_cliente_netmultix + "%'").first


          cia = '1'
          fecha = Time.now
          orden_compra = self.solicitud.orden_compra rescue 'sin-orden'
          sol_servicio = self.solicitud.codigo rescue 'sin-codigo|sol_servicio'
          servicio = 201
          tipo = 'S'
          proyecto = '2033000238'
          descripcion = self.servicio.nombre rescue 'sin-descripcion|nombre-servicio'
          concepto_factura = self.concepto_en_extenso rescue 'sin-concepto-extenso'
          cliente_netmultix_cve = cliente_netmultix.cl01_clave rescue 'sin-clave-cliente-net'
          cliente_netmultix_nombre = cliente_netmultix.cl01_nombre rescue 'sin-nombre-cliente-net'
          cliente_netmultix_rfc = cliente_netmultix.cl01_rfc rescue 'sin-rfc-cliente-net'

          cliente_netmultix_calle = cliente_netmultix.cl01_calle rescue 'sin-calle-cliente-net'
          cliente_netmultix_colonia = cliente_netmultix.cl01_colonia rescue 'sin-colonia-cliente-net'
          cliente_netmultix_ciudad = cliente_netmultix.cl01_ciudad rescue 0
          cliente_netmultix_postal = cliente_netmultix.cl01_postal rescue 'sin-postal-cliente-net'
          cliente_netmultix_lada = cliente_netmultix.cl01_lada rescue 'sin-lada-cliente-net'
          cliente_netmultix_telefono = cliente_netmultix.cl01_telefono1 rescue 'sin-tel1-cliente-net'
          cliente_netmultix_fax = cliente_netmultix.cl01_fax rescue 'sin-fax-cliente-net'

          requisitor = self.servicio.empleado.nombre_completo

          puts cia
          puts fecha
          puts orden_compra
          puts sol_servicio
          puts servicio
          puts tipo
          puts proyecto
          puts descripcion
          puts concepto_factura
          puts cliente_netmultix_cve
          puts cliente_netmultix_nombre
          puts cliente_netmultix_rfc
          puts cliente_netmultix_calle
          puts cliente_netmultix_colonia
          puts cliente_netmultix_ciudad
          puts cliente_netmultix_postal
          puts cliente_netmultix_lada
          puts cliente_netmultix_telefono
          puts cliente_netmultix_fax
          puts requisitor

          cedulaNetMultix = CedulaNetmultix.where('ft16_sol_servicio LIKE :q', {:q => '%999/17%'}).first
          puts cedulaNetMultix.ft16_cedula rescue 'no cedula'
          self.cedula_netmultix = cedulaNetMultix.ft16_cedula

          self.save
       end
    end


  end
end
