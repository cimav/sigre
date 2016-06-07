require_dependency "vinculacion/application_controller"
#require "#{Rails.root}/apps/vinculacion/app/uploaders/vinculacion/archivo_uploader"

module Vinculacion
  class ArchivosController < ApplicationController
  	def index
  	  @nuevo_archivo = Archivo.new
  	  @nuevo_archivo.solicitud_id = params[:solicitud_id]
  	  @usuario_id = current_user.id
      @archivos = Archivo.where(:solicitud_id => params[:solicitud_id])
      render :layout => 'standalone'
    end

    def show
      render json: Archivo.find(params[:id])
    end

    def create
      a = Archivo.create(archivo)
      redirect_to "/vinculacion/solicitudes/#{a.solicitud_id}/archivos"
    end

    def update
      a = Archivo.find(params[:id]).tap { |b| b.update_attributes(archivo) }
      redirect_to "/vinculacion/solicitudes/#{a.solicitud_id}/archivos"
    end

    def destroy
      render json: Archivo.find(params[:id]).destroy
    end

    def file
      a = Archivo.find(params[:id])
      send_file a.archivo.to_s, :x_sendfile=>true
    end 

    protected
    def archivo
      params[:archivo].permit(:solicitud_id,
                              :archivo,
                              :usuario_id,
                              :tipo_archivo,
                              :descripcion,
                              :status)
    end
  end
end
