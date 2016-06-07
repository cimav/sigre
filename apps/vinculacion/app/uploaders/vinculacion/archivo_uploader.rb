# encoding: utf-8

module vinculacion
  class ArchivoUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
      "#{Rails.root}/private/solicitud/#{model.solicitud_id}/archivos/"
    end
  end
end
