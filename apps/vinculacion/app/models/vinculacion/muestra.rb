module Vinculacion
  class Muestra < ActiveRecord::Base
    belongs_to :solicitud
    has_and_belongs_to_many :servicios, :join_table => :vinculacion_servicios_muestras

    has_many :muestra_detalle,  :dependent => :destroy

    after_create :set_extra
    after_update :update_detalles

    INICIAL    = 1
    EN_USO     = 2

    def set_extra
      con = Muestra.where(:solicitud_id => self.solicitud_id).maximum('consecutivo')
    
      if con.nil?
        con = 1
      else
        con += 1
      end
      consecutivo = "%03d" % con
      self.consecutivo = con
      self.codigo = "#{self.solicitud.codigo}-#{consecutivo}"
      self.status = Muestra::INICIAL

      self.save(:validate => false)
    end

    def update_detalles
      if self.cantidad_changed?
        from = self.cantidad_was === nil ? 0 : self.cantidad_was # was es nil cuando es creacion de la muestra
        to = self.cantidad_change[1]
        if from > to
          n = from - to
          # eliminar los ultimos n registros
          detalles = MuestraDetalle.where("muestra_id = #{self.id}").order("consecutivo desc").limit(n)
          detalles.destroy_all
        else
          # insertar n registros al final
          for con in from+1..to
            detalle = MuestraDetalle.create(:muestra_id => self.id, :consecutivo => con, :cliente_identificacion => self.identificacion, :status=> 1 )
          end
        end

        # actualizar cantidad de cotizacion_detalle si existe servicio ligado a la muestra
        # solo de la ultima cotizacion
        ultima_cotizacion = Cotizacion.where("solicitud_id = :s_id", {:s_id => self.solicitud_id}).order('created_at').last
        if !ultima_cotizacion.nil?
          ultima_cotizacion.cotizacion_detalle.where("servicio_id IS NOT NULL").each do |detalle|
            servicio_id = detalle.servicio_id
            servicio_muestra = ServiciosMuestras.where("servicio_id = :srv_id AND muestra_id = :muestra_id", {:srv_id => servicio_id, :muestra_id => self.id})
            if !servicio_muestra.nil?
              detalle.cantidad = self.cantidad
              detalle.save
            end
          end
        end

        # reordenar en un solo consecutivo todo los detalles de todas las muestras
        muestras = Muestra.where(:solicitud_id => self.solicitud_id).order("id")
        con = 1
        muestras.each do |muestra|
          detalles = MuestraDetalle.where("muestra_id = #{muestra.id}")
          detalles.each do |detalle|
            detalle.consecutivo = con
            detalle.save
            con += 1
          end
        end
      end
    end

  end
end
