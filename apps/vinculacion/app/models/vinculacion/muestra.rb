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
        if self.cantidad_was > self.cantidad_change[1]
          n = self.cantidad_was - self.cantidad_change[1]
          # eliminar los ultimos n registros
          detalles = MuestraDetalle.where("muestra_id = #{self.id}").order("consecutivo desc").limit(n)
          detalles.destroy_all
        else
          n = self.cantidad_change[1] - self.cantidad_was
          # insertar n registros al final
          for con in self.cantidad_was+1..self.cantidad_change[1]
            detalle = MuestraDetalle.create(:muestra_id => self.id, :consecutivo => con, :cliente_identificacion => self.identificacion, :status=> n )
          end
        end

        puts "fin >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "
      end
    end

  end
end
