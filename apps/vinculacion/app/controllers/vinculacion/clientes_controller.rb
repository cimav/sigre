require_dependency "vinculacion/application_controller"
require_dependency "spreadsheet"

module Vinculacion
  class ClientesController < ApplicationController
    def index
      results = Cliente.includes(:pais,:estado, :contactos).order(:razon_social)
      render json: results, include: 'contactos,pais,estado'
    end

    def show
      render json: Cliente.find(params[:id])
    end

    def create
      render json: Cliente.create(cliente)
    end

    def update
      render json: Cliente.find(params[:id]).tap { |b| b.update_attributes(cliente) }
    end

    def destroy
      Cliente.find(params[:id]).destroy
      render :json => true, :status => :ok
    end

    def listado
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet :name => 'CLIENTES'
      header_format = Spreadsheet::Format.new :color => :black, :weight => :bold
      sheet1.row(0).default_format = header_format

      rownum = 0
      sheet1.row(rownum).push "UNO"
      
      # for row in rows
      #   rownum += 1
      #   for column in column_order
      #     sheet1.row(rownum).push row[column].nil? ? 'N/A' : row[column]
      #   end
      # end
      t = Time.now
      filename = "listado-clientes-#{t.strftime("%Y%m%d%H%M%S")}"
      book.write "tmp/#{filename}.xls"
      send_file "tmp/#{filename}.xls", :x_sendfile=>true
        
    end

    protected
    def cliente
      params[:cliente].permit(
          :id,
          :rfc,
          :razon_social,
          :num_empleados,
          :calle_num,
          :colonia,
          :cp,
          :telefono,
          :fax,
          :email,
          :tamano_empresa,
          :sector,
          :pais_id,
          :estado_id,
          :ciudad
      )
    end
  end
end
