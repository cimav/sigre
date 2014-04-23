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

      @cotiza = cotizacion
      letra = @cotiza[:consecutivo]
      if letra.nil?
        # es la 1era cotizacion, valores por default
         letra = 'A'
         @cotiza[:condicion] = 1 # ember.controller.app.condiciones
         @cotiza[:idioma] = 1
         @cotiza[:divisa] = 1
         @cotiza[:comentarios] = 'Los comentarios default de la cotización'
         @cotiza[:observaciones] = 'Las observaciones default'
         @cotiza[:notas] = 'La o las notas por omisión'
         @cotiza[:subtotal] = 0.00
         @cotiza[:precio_venta] = 0.00
         @cotiza[:precio_unitario] = 0.00
         @cotiza[:descuento_porcentaje] = 0.00
         @cotiza[:descuento_status] = 0
         @cotiza[:msg_notificacion] = ''
         @cotiza[:motivo_status] = ''
         @cotiza[:duracion] = 0
      else
        # clonar la cotizacion anterior y agrega el consecutivo
         letra = letra.next
       end
      @cotiza[:consecutivo] = letra
      @cotiza[:status] = 1 #edicion #ember.CotizacionController.Status

      @cotiza = Cotizacion.create(@cotiza)

      render json: @cotiza
    end

    def update
      render json: Cotizacion.find(params[:id]).tap { |b| b.update_attributes(cotizacion) }
    end

    def destroy
      render json: Cotizacion.find(params[:id]).destroy
    end

    def document
      c_id = params[:id]
      type = params[:type]
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
        pdf.text_box "Centro de Investigación en Materiales Avanzados, S.C.", :at=> [x,y], :width => w, :height => h, :style=> :bold, :valign=> :center, :align => :center, :size=> size
        y = y - 15
        h = 40
        
        ## DIRECCION
        pdf.text_box "Miguel de Cervantes 120, Complejo Industrial Chihuahua\n Chihuahua, Chihuahua. México.\n (614) 439 11 91", :at=> [x,y], :width => w, :height => h,:valign=> :center, :align => :center, :size=> size
        
        ## FECHA Y COTIZACION
        pdf.text "\n\n\n\n\n05 de Marzo del 2014. \n Número de cotización: 123456", :style=> :bold, :align=> :right, :size=> size
        
        ## DATOS GENERALES
        data = [["Empresa:","Tecnologías de flujo"],["Atención","Saúl Arredondo"],["Dirección:","Miguel de Cervantes"],["Teléfono:","614 123 4567"],["Email:","saul.arredondo@emerson.com"]]
        pdf.table(data,:header=> false,:cell_style=> {:align=>:left,:size=>size,:padding=>1,:borders=>[]},:column_widths=>[80,410]) 
        
        ## TEXTO
        pdf.text "\n\n\nEn respuesta a su solicitud para traducción de informe y agradeciendo su preferencia, ponemos a su consideración la siguiente propuesta económica: ", :size => size
        
        ## CABECERA
        data = [["Cantidad","Descripción",  "Costo \nUnitario", "Subtotal"]]
        ## REITERATIVOS
        counter = 0
        ([["1","Traducción de Informa a idioma ingles.","$1,500.00","$1,500.00"]] * 1).each do |r|
          data += [r]
	  counter = counter + 1
        end
        ## FINAL
        data +=[["","","Subtotal","$1,500.00"],["","","Iva","$240.00"],["","","Total","$1,740.00"]]
        pdf.table(data,:header=> false,:width=>490,:cell_style=> {:align=>:center,:valign=>:center,:size=>size - 2,:padding=>3}) do 
          row(counter + 1).column(0..2).style(:borders=>[])
          row(counter + 2).column(0..2).style(:borders=>[])
          row(counter + 3).column(0..2).style(:borders=>[])
        end 
        # NOTAS
        pdf.text "\n\n\n\n\n Notas: \n\n Esta cotización tiene una vigencia de 30 días hábiles.\n\n La duración del servicio es de 30 días hábiles posteriores a la recepción de la orden de compra.", :size=> size
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

