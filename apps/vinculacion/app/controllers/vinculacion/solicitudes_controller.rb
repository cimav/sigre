# coding: utf-8
require_dependency "vinculacion/application_controller"
require 'resque-bus'

module Vinculacion
  class SolicitudesController < ApplicationController
  	def index
      results = Solicitud.includes(:proyecto).order(:id)
      if !params[:q].blank?
        results = results.where("(descripcion LIKE :q OR vinculacion_proyectos.nombre LIKE :q)", {:q => "%#{params[:q]}%"})
      end
      render json: results
    end

    def estado_actual
      solicitud = Solicitud.find(params[:id])
      if solicitud 
        status = solicitud.status
      else
        status = 0
      end
      render json: status
    end

    def show
      render json: Solicitud.find(params[:id])
    end

    def create 
      solicitud_params = solicitud
      solicitud_params[:usuario_id] = current_user.id
      render json: Solicitud.create(solicitud_params)
    end

    def update
      render json: Solicitud.find(params[:id]).tap { |b| b.update_attributes(solicitud) }
    end

    def destroy
      render json: Solicitud.find(params[:id]).destroy
    end

    def notificar_cancelacion
      solicitud = Solicitud.find(params[:id])

      # notificar a Bitacora
      QueueBus.publish('notificar_cancelacion',
                        'solicitud_id' => solicitud.id,
                        'agente_id'      => solicitud.usuario.id,
                        'agente_email'   => solicitud.usuario.email)  #  del usuario que da de alta el servicio.

      render json: solicitud
    end

    def notificar_arranque
      solicitud = Solicitud.find(params[:id])

      # notificar a Bitacora
      QueueBus.publish('notificar_arranque',
                        'solicitud_id' => solicitud.id,
                        'agente_id'      => solicitud.usuario.id,
                        'agente_email'   => solicitud.usuario.email)  #  del usuario que da de alta el servicio.

      render json: solicitud
    end

    def notificar_arranque_no_coordinado
      solicitud = Solicitud.find(params[:id])
      servicio = solicitud.servicios[0]

      bitacoraId = servicio.servicio_bitacora.bitacora_id rescue 0

      # notificar a Bitacora
      puts "Notificar arranque no coordinado"
      QueueBus.publish('notificar_arranque_no_coordinado',
                        'id'                    => servicio.id,
                        'solicitud_id'          => solicitud.id,
                        'agente_id'             => solicitud.usuario.id,
                        'agente_email'          => solicitud.usuario.email,      #  del usuario que da de alta el servicio.
                        'carpeta_codigo'        => solicitud.codigo,
                        'servicio_codigo'       => servicio.codigo,
                        'servicio_bitacora_id'  => bitacoraId,
                        'nombre'                => servicio.nombre,
                        'cliente_id'            => solicitud.cliente_id,
                        'cliente_nombre'        => solicitud.cliente.razon_social,
                        'descripcion'           => solicitud.descripcion,
                        'muestra'               => solicitud.muestras[0]
      )
      render json: solicitud
    end

    def estimacion_costos
      type      = params[:type]
      solicitud = Solicitud.find(params[:id])
      ## Load locale config
      t = t(:apps)[:vinculacion][:controllers][:cotizaciones][:document]
      ## Default Page Size Is Letter
      ## Default Font Is Helvetica
      Prawn::Document.new(:top_margin => 50.0, :bottom_margin=> 100.0, :left_margin=>70.0, :right_margin=>45.0) do |pdf|
        image = "#{Rails.root}/private/images/logo_cimav_100.png" 
        pdf.image image, :position => :left, :height => 50
        x = 100
        y = 640
        w = 350
        h = 28
        size = 11
        pdf.text_box t[:center], :at=> [x,y], :width => w, :height => h,  :valign=> :top, :align => :left, :size=> 13
        
        ## DIRECCIONES
        y = y - 30
        h = 40
        pdf.text_box t[:address0], :at=> [x,y], :width => w, :height => h,:valign=> :top, :align => :left, :size=> 5
        x = x + 110
        pdf.text_box t[:address1], :at=> [x,y], :width => w, :height => h,:valign=> :top, :align => :left, :size=> 5
        x = x + 90
        pdf.text_box t[:address2], :at=> [x,y], :width => w, :height => h,:valign=> :top, :align => :left, :size=> 5
        
        ## LINE
        x = 0
        y = y - 35 
        pdf.stroke_color= "000000"
        pdf.line_width= 3
        pdf.stroke_line [x,y],[350,y]
        pdf.line_width= 1
        pdf.stroke_line [x,y - 3],[350,y - 3]
        pdf.text_box "ESTIMACIÓN DE COSTOS", :at=> [351,y + 3 ], :width => 140, :style => :bold_italic, :height => 13, :valign=> :top, :align => :center, :size=> 11
        pdf.line_width= 3
        pdf.stroke_line [493,y],[513,y]
        pdf.line_width= 1
        pdf.stroke_line [493,y - 3],[513,y - 3]

        ## ALGUNOS SALTOS DE LINEA PARA BAJAR LA TABLA
        pdf.text "\n\n\n\n\n"
        proyecto_title  = "#{solicitud.proyecto.cuenta} #{solicitud.proyecto.descripcion}"
        solicitud_title = "#{solicitud.codigo}"
        x = x + 10
        pdf.text_box "Proyecto:", :at=> [x,y -20], :width => 55, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box proyecto_title, :at=> [x + 90,y -20], :width => 400, :height => 13,:valign=> :top, :align => :left, :size=> 12
        y = y - 15
        pdf.text_box "Solicitud:", :at=> [x,y -20], :width => 55, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box solicitud_title, :at=> [x + 90,y -20], :width => 200, :height => 13,:valign=> :top, :align => :left, :size=> 12
        y = y - 15
        rp = "#{solicitud.responsable_presupuestal.nombre rescue "Sin"} #{solicitud.responsable_presupuestal.apellido_paterno rescue "Asignar"} #{solicitud.responsable_presupuestal.apellido_materno rescue ""}"
        pdf.text_box "Responsable:", :at=> [x,y -20], :width => 95, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box rp, :at=> [x + 90,y -20], :width => 200, :height => 13,:valign=> :top, :align => :left, :size=> 12

        ## RODEAMOS
        y = 560
        pdf.line_width= 0.1
        pdf.stroke_rounded_rectangle([0,y], 500, 50, 10)
        #pdf.stroke_rounded_rectangle([360,y], 145, 80, 10)
        
        #### PRESUPUESTO PROGRAMADO
        pdf.text "\n\n"
        pdf.text "Presupuesto Programado", :size=> 15,:style=> :bold
        data = []
        subtotal_consumibles = 0
        subtotal_otros       = 0 
        subtotal_hhombre     = 0
        total_consumibles    = 0
        total_otros          = 0 
        total_hhombre        = 0
        data_consumibles     = []
        data_otros           = []
        data_hhombre         = []
        ssccd_spaces         = "#{Prawn::Text::NBSP * 6}"
        solicitud.servicios.each do |ss|
          ss.costeos.each do |ssc|
            ssc.costeo_detalle.order(:tipo,:descripcion).each do |ssccd|
              subtotal_consumibles = 0
              subtotal_otros       = 0 
              subtotal_hhombre     = 0
              cantidad = 0
              if ssccd.cantidad.to_i.eql? 0
                cantidad = 1
              else
                cantidad = ssccd.cantidad
              end
              
              if ssccd.tipo.to_i.eql? 1 then
                subtotal_hhombre = ssccd.precio_unitario * cantidad
                if data_hhombre.empty?
                  data_hhombre += [["#{ssccd_spaces} #{ssccd.descripcion}",subtotal_hhombre]]
                else
                  counter = 0
                  data_hhombre.each do |dhh|
                    if dhh[0] == "#{ssccd_spaces} #{ssccd.descripcion}" then
                       data_hhombre[counter][1] = dhh[1] + subtotal_hhombre
                       break;
                    else
                      data_hhombre += [["#{ssccd_spaces} #{ssccd.descripcion}",subtotal_hhombre]]
                      break;
                    end
                    counter= counter + 1
                  end
                end
                total_hhombre = total_hhombre + subtotal_hhombre
              elsif ssccd.tipo.to_i.eql? 3 then
                subtotal_consumibles = ssccd.precio_unitario * cantidad
                if data_consumibles.empty? then
                  data_consumibles += [["#{ssccd_spaces}  #{ssccd.descripcion}",subtotal_consumibles]]
                else
                  counter = 0
                  data_consumibles.each do |dt|
                    if dt[0] == "#{ssccd_spaces}  #{ssccd.descripcion}" then
                       data_consumibles[counter][1] = dt[1] + subtotal_consumibles   
                       break;
                    else
                       data_consumibles += [["#{ssccd_spaces}  #{ssccd.descripcion}",subtotal_consumibles]]
                       break;
                    end
                    counter= counter + 1
                  end
                end
                total_consumibles = total_consumibles + subtotal_consumibles
              elsif ssccd.tipo.to_i.eql? 4 then
                subtotal_otros = ssccd.precio_unitario * cantidad
                if data_otros.empty? then
                  data_otros += [["#{ssccd_spaces} #{ssccd.descripcion}",subtotal_otros]]
                else
                  counter = 0
                  data_otros.each do |dot|
                    if dot[0] == "#{ssccd_spaces}  #{ssccd.descripcion}" then
                      data_otros[counter][1] = dot[1] + subtotal_otros
                      break;
                    else
                      data_otros += [["#{ssccd_spaces} #{ssccd.descripcion}",subtotal_otros]]
                      break;
                    end
                    counter = counter + 1
                  end
                end
                total_otros = total_otros + subtotal_otros
              end
            end
          end
        end
        
        title_spaces = "#{Prawn::Text::NBSP * 2}"
        ## CONSUMIBLES
        data += [[ {:content=>"#{title_spaces} <b>Insumos</b> ",:colspan=>2}  ]]
        data += data_consumibles
        data += [[{:content=>"Subtotal #{title_spaces}",:align=>:right},total_consumibles]]
        # OTROS
        data += [[ {:content=>"#{title_spaces} <b>Otros</b> ",:colspan=>2}  ]]
        data += data_otros
        data += [[{:content=>"Subtotal #{title_spaces}",:align=>:right},total_otros]]
         
        pdf.table(data,:width=>505,:cell_style=>{:size=>size - 2,:padding=>3,:border_width=>0.1,:inline_format => true})
        
        ##  COSTOS INDIRECTOS
        pdf.text "\n"
        pdf.text "Personal", :size=> 15,:style=> :bold
        data = []
        data += [[ {:content=>"#{title_spaces} <b>Horas hombre</b> ",:colspan=>2}  ]]
        data += data_hhombre
        data += [[{:content=>"Subtotal #{title_spaces}",:align=>:right},total_hhombre]]
        pdf.table(data,:width=>505,:cell_style=>{:size=>size - 2,:padding=>3,:border_width=>0.1,:inline_format => true})
        
        pdf.text "\n"
        data = []
        data += [[{:content=>"Total #{title_spaces}",:align=>:left},total_otros+total_consumibles+total_hhombre]]
        pdf.table(data,:width=>250,:cell_style=>{:size=>size - 2,:padding=>3,:border_width=>0.1,:inline_format => true})
 
        ### ENVIANDO EL PDF
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end

      
    end

    protected
    def solicitud
      params[:solicitud].permit(:consecutivo,
                                :codigo,
                                :proyecto_id,
                                :sede_id,
                                :prioridad,
                                :cliente_id,
                                :contacto_id,
                                :responsable_presupuestal_id,
                                :descripcion,
                                :usuario_id,
                                :status,
                                :motivo_status,
                                :razon_cancelacion,
                                :orden_compra,
                                :fecha_inicio,
                                :fecha_termino,
                                :tipo,
                                :duracion,
                                :tiempo_entrega
      )
    end
  end
end
