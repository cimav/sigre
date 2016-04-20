require_dependency "vinculacion/application_controller"

module Vinculacion
  class RegistroNotasController < ApplicationController
    def index
      results = RegistroNota.order(:registro_id)
      
      render json: results
    end

    def show
      render json: RegistroNota.find(params[:id])
    end

    def create
      nota_params = registro_nota
      nota_params[:usuario_id] = current_user.id
      if nota_params[:alerta_id].to_i > 0
        nota_params[:registro_id] = nota_params[:alerta_id]
      end
      registro = Registro.find(nota_params[:registro_id])
      if registro.tipo = Registro::TIPO_ALERTA
        registro.status = Registro::STATUS_ALERTA_CONTESTADA
        registro.save!
      end
      render json: RegistroNota.create(nota_params.except(:alerta_id))
    end

    def update
      render json: RegistroNota.find(params[:id]).tap { |b| b.update_attributes(registro_nota.except(:alerta_id)) }
    end

    def destroy
      render json: RegistroNota.find(params[:id]).destroy
    end

    protected
    def registro_nota
      params[:registro_nota].permit(:registro_id,
                              :alerta_id,
                              :usuario_id,
                              :mensaje)
    end
  end
end
