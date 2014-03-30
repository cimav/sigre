module Vinculacion
  class Costeo < ActiveRecord::Base
    belongs_to :servicio 
    #belongs_to :muestra
    has_many :costeo_detalle

    after_create :set_extra

    def set_extra
      con = Costeo.where(:servicio_id => self.servicio_id).maximum('consecutivo')
      if con.nil?
        con = 1
      else
        con += 1
      end
      consecutivo = "%03d" % con
      self.consecutivo = con
      self.codigo = "#{self.servicio.codigo}-C#{consecutivo}"
      self.save(:validate => false)
    end

  end
end
