module Vinculacion
  class Muestra < ActiveRecord::Base
  	belongs_to :solicitud
    has_and_belongs_to_many :servicios, :join_table => :vinculacion_servicios_muestras

  	after_create :set_extra

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
      self.save(:validate => false)
  	end

  end
end
