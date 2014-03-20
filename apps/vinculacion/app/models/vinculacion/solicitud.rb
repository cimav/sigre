module Vinculacion
  class Solicitud < ActiveRecord::Base
  	has_many :muestras
    has_many :servicios

  	after_create :set_extra

  	def set_extra
  	  con = Solicitud.where("EXTRACT(YEAR FROM created_at) = :year", {:year => Date.today.year}).maximum('consecutivo')
      if con.nil?
        con = 1
      else
        con += 1
      end
      consecutivo = "%04d" % con
      self.consecutivo = con
      year = Date.today.year.to_s.last(2)
      self.codigo = "#{year}/#{consecutivo}"
      self.save(:validate => false)
  	end

  end
end
