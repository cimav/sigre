require_dependency "vinculacion/application_controller"

module Vinculacion
  class CedulasController < ApplicationController

    def index
      results = Cedula.order(:codigo)
      render json: results
    end

    def show
      render json: Cedula.find(params[:id])
    end

    def create
      render json: Cedula.create(cedula_params)
    end

    def update
      render json: Cedula.find(params[:id]).tap { |b| b.update_attributes(cedula_params) }
    end

    def destroy
      render json: Cedula.find(params[:id]).destroy
    end

    def subproyecto

      codigo_solicitud = params[:codigo_solicitud]

      # busca la solicitud/servicio en la descripción
      proy_netmultix = ProyectoNetmultix.where('trim(pr13_desc) LIKE trim(:q)', {:q => codigo_solicitud}).first rescue nil

      if !proy_netmultix.nil?
        # si el subproyecto existe en NetMultix
        sub_proyecto = proy_netmultix.pr13_subproyecto rescue '00000'
      else
        # si no existe, toma el subproyecto default por sede
        case current_user.sede_id
          when 2 # MTY
            sub_proyecto = '2035000001'
          when 3 # DGO
            sub_proyecto = '2040900001'
          else # CHI
            sub_proyecto = '2033000238'
        end
        #sub_proyecto = proyecto_id.to_s + sub_proyecto
        #proy_netmultix = ProyectoNetmultix.where('pr13_subproyecto LIKE :q', {:q => sub_proyecto}).first rescue nil
      end

      #render json:  { :subproyecto => sub_proyecto }.to_json
      render text: sub_proyecto

    end

    protected
    def cedula_params
      params[:cedula].permit(:solicitud_id,
                               :servicio_id,
                               :codigo,
                               :status,
                               :cedula_netmultix,
                               :cliente_netmultix_id,
                               :concepto_en_extenso,
                               :proyecto_id,
                               :sub_proyecto
                                )
    end
  end
end
