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
      rownum = 0
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet :name => 'CLIENTES'
      header_format = Spreadsheet::Format.new :color => :black, :weight => :bold
      sheet1.row(rownum).default_format = header_format

      sheet1.row(rownum).push "RAZON SOCIAL"
      sheet1.row(rownum).push "RFC"
      sheet1.row(rownum).push "NUM EMPLEADOS"
      sheet1.row(rownum).push "CALLE"
      sheet1.row(rownum).push "COLONIA"
      sheet1.row(rownum).push "CP"
      sheet1.row(rownum).push "PAIS"
      sheet1.row(rownum).push "ESTADO"
      sheet1.row(rownum).push "CIUDAD"
      sheet1.row(rownum).push "TELEFONO"
      sheet1.row(rownum).push "FAX"
      sheet1.row(rownum).push "EMAIL"
      sheet1.row(rownum).push "TAMAÑO"
      sheet1.row(rownum).push "SECTOR"
      sheet1.row(rownum).push "ULTIMO SERVICIO"
      sheet1.row(rownum).push "PENULTIMO SERVICIO"
      sheet1.row(rownum).push "ANTEPENULTIMO SERVICIO"
      sheet1.row(rownum).push "CONTACTO"
      sheet1.row(rownum).push "TELEFONO"
      sheet1.row(rownum).push "EMAIL"
      
      clientes = Cliente.includes(:pais, :estado, :contactos).order(:razon_social)
      clientes.each do |c|
        row = []
        row << c.razon_social.to_s
        row << c.rfc.to_s
        row << c.num_empleados.to_s
        row << c.calle_num.to_s
        row << c.colonia.to_s
        row << c.cp.to_s
        pais = c.pais.nombre.to_s rescue ''
        estado = c.estado.nombre.to_s rescue ''
        row << pais
        row << estado
        row << c.ciudad.to_s
        row << c.telefono.to_s
        row << c.fax.to_s
        row << c.email.to_s
        row << c.tamano_empresa.to_s
        row << c.sector.to_s

      

        c.solicitudes.order('created_at DESC').limit(3).each do |solicitud|
          codigo = solicitud.codigo rescue '' 
          desc = solicitud.descripcion rescue '' 
          cod_desc = codigo.to_s + ': ' + desc.to_s
          row << cod_desc
        end


        if c.contactos.count > 0
          
          c.contactos.order(:nombre).each do |contacto|
            nombre = contacto.nombre rescue ''
            telefono = contacto.telefono rescue ''
            email    = contacto.email rescue ''

            rowc = row.dup
            rowc << nombre.to_s
            rowc << telefono.to_s
            rowc << email.to_s

            
            rownum += 1
            rowc.each do |r|
              sheet1.row(rownum).push r 
            end
          end

        else
          rownum += 1
          row.each do |r|
            sheet1.row(rownum).push r 
          end
        end
        
        # xxx = xxx + "\n"


      end  

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
