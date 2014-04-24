# coding: utf-8
require_dependency "vinculacion/application_controller"

module Vinculacion
  class CotizacionesController < ApplicationController
    def index
      results = Cotizacion.where(:solicitud_id => params[:solicitud_id])
      render json: results
    end

    def show
      render json: Cotizacion.find(params[:id])
    end

    def create
      render json: Cotizacion.create(cotizacion)
    end

    def update
      render json: Cotizacion.find(params[:id]).tap { |b| b.update_attributes(cotizacion) }
    end

    def destroy
      render json: Cotizacion.find(params[:id]).destroy
    end

    def document
      type = params[:type]
      cotizacion=  Cotizacion.find(params[:id])
      ## Load locale config
      t = t(:apps)[:vinculacion][:controllers][:cotizaciones][:document]
      ## Default Page Size Is Letter
      ## Default Font Is Helvetica
      Prawn::Document.new(:top_margin => 70.0, :bottom_margin=> 80.0, :left_margin=>70.0, :right_margin=>45.0) do |pdf|
        image = "#{Rails.root}/private/images/logo_cimav_100.png" 
        pdf.image image, :position => :left, :height => 70
        x = 170
        y = 632
        w = 350
        h = 13
        size = 11
        pdf.text_box t[:center], :at=> [x,y], :width => w, :height => h, :style=> :bold, :valign=> :center, :align => :center, :size=> size
        y = y - 15
        h = 40
        
        ## DIRECCION
        pdf.text_box t[:address], :at=> [x,y], :width => w, :height => h,:valign=> :center, :align => :center, :size=> size
        
        ## FECHA 
        dia   = cotizacion.fecha_notificacion.day
        mes   = t(:date)[:month_names][cotizacion.fecha_notificacion.month]
        anyo  = cotizacion.fecha_notificacion.year
        ## CALCULANDO FOLIO
        anyof       = anyo.to_s[2,4]
        con         = cotizacion.solicitud.consecutivo
        c_solicitud = "%03d" % con.to_i
        c_cotizacion = cotizacion.consecutivo
        folio = "#{anyof}/#{c_solicitud}-#{c_cotizacion}"
        pdf.text "\n\n\n\n\n#{dia} de #{mes} del #{anyo}. \n #{t[:quote]} #{folio}", :style=> :bold, :align=> :right, :size=> size
        
        ## DATOS GENERALES
        cliente  = cotizacion.solicitud.cliente      
        contacto = cotizacion.solicitud.contacto
    
        data = [[t[:company],cliente.razon_social],
                [t[:attention],contacto.nombre],
                [t[:company_address],"#{cliente.calle_num} Col. #{cliente.colonia} C.P. #{cliente.cp}"],
                [t[:phone],contacto.telefono],
                [t[:email],contacto.email]]

        pdf.table(data,:header=> false,:cell_style=> {:align=>:left,:size=>size,:padding=>1,:borders=>[]},:column_widths=>[80,410]) 
        
        ## TEXTO
        pdf.text "\n\n\n #{t[:text0]}", :size => size
        
        ## CABECERA
        data = [[t[:amount],t[:description],t[:unit_cost], t[:subtotal]]]
        ## REITERATIVOS
        counter   = 0
        subtotalf = 0
        cotizacion.cotizaciones_detalle.each do |cd|
          subtotal = cd.precio_unitario * cd.cantidad
          r = [[cd.cantidad,cd.concepto,cd.precio_unitario.to_s,subtotal.to_s]]
          data += r
          counter = counter + 1
          subtotalf += subtotal
        end

        ## CALCULANDO EL IVA
        iva = (subtotalf * cotizacion.iva)/100

        ## FINAL
        data +=[["","",t[:subtotal],subtotalf],["","","Iva",iva],["","","Total",(subtotalf + iva).to_s]]
        pdf.table(data,:header=> false,:width=>490,:cell_style=> {:align=>:center,:valign=>:center,:size=>size - 2,:padding=>3}) do 
          row(counter + 1).column(0..2).style(:borders=>[])
          row(counter + 2).column(0..2).style(:borders=>[])
          row(counter + 3).column(0..2).style(:borders=>[])
        end 
        # NOTAS
        pdf.text "\n\n\n\n\n #{t[:notes]}", :size=> size
        # RENDER
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end

    protected
    def cotizacion
      params[:cotizacion].permit(
          :id,
          :solicitud_id,
          :consecutivo,
          :fecha_notificacion,
          :condicion,
          :idioma,
          :divisa,
          :comentarios,
          :observaciones,
          :notas,
          :subtotal,
          :iva,
          :precio_venta,
          :precio_unitario,
          :descuento_porcentaje,
          :descuento_status,
          :status,
          :msg_notificacion,
          :motivo_status,
          :duracion
      )
    end
  end
end

