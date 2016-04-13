require_dependency "vinculacion/application_controller"

module Vinculacion
  class PaisesNetmultixController < ApplicationController

    def index
      render json: PaisNetmultix.order(:cl12_pais)
    end

    def show
      pais = "#{params[:id]}".strip.to_i
      result = PaisNetmultix.where("(cl12_pais = :q)", {:q => pais})
      render json: result
    end

  end
end