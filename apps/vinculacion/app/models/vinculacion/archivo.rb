module Vinculacion
  class Archivo < ActiveRecord::Base
  	belongs_to :solicitud
  	mount_uploader :archivo, ArchivoUploader

    ARCHIVO_CLIENTE = 1
    ORDEN_DE_COMPRA = 2

    TIPO = {
    	ARCHIVO_CLIENTE => "Archivo del cliente",
    	ORDEN_DE_COMPRA => "Orden de compra" 
    }

    def tipo_text
      TIPO[tipo_archivo]
    end

  end
end
