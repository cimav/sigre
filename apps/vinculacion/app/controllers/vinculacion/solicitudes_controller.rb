# coding: utf-8
require_dependency "vinculacion/application_controller"
require 'resque-bus'

module Vinculacion
  class SolicitudesController < ApplicationController

    skip_before_filter :auth_required, :only => :estimacion_costos_hash

    @bitacora_env = "bitacora_production" # "bitacora_#{Rails.env}"

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
      s = Solicitud.create(solicitud_params)

      if (s.tipo == 4)
        # Si es proyecto entonces crear servicio dummy para agregar costeos.
        serv = s.servicios.new
        serv.nombre = "Proyecto #{s.codigo}"
        serv.descripcion = s.descripcion
        serv.empleado_id = s.responsable_presupuestal_id
        serv.save
      end
      render json: s
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
                        'solicitud_id'   => solicitud.id,
                        'fecha_inicio'   => solicitud.fecha_inicio,
                        'fecha_termino'  => solicitud.fecha_termino,
                        'duracion'       => solicitud.duracion,
                        'tiempo_entrega' => solicitud.tiempo_text,
                        'agente_id'      => solicitud.usuario.id,
                        'agente_email'   => solicitud.usuario.email)  #  del usuario que da de alta el servicio.

      render json: solicitud
    end

    def notificar_arranque
      solicitud = Solicitud.find(params[:id])

      # Muestras
      muestras = []
      solicitud.muestras.each do |muestra|
        muestras_detalle = []
        muestra.muestra_detalle.each do |detalle|
          muestras_detalle << detalle
        end
        muestra_item = {
            'muestra'  => muestra,
            'detalles' => muestras_detalle
        }
        muestras << muestra_item
      end

      # notificar a Bitacora
      puts "NOTIFICAR ARRANQUE..."
      QueueBus.publish('notificar_arranque',
                        'solicitud_id' => solicitud.id,
                        'agente_id'      => solicitud.usuario.id,
                        'fecha_inicio'   => solicitud.fecha_inicio,
                        'fecha_termino'  => solicitud.fecha_termino,
                        'duracion'       => solicitud.duracion,
                        'tiempo_entrega' => solicitud.tiempo_text,
                        'agente_email'   => solicitud.usuario.email,
                        'muestras'       => muestras
                        )  #  del usuario que da de alta el servicio.
      puts "NOTIFICADO"

      render json: solicitud
    end

    def notificar_arranque_no_coordinado
      solicitud = Solicitud.find(params[:id])
      servicio = solicitud.servicios[0]

        cliente_id = solicitud.cliente_id
        cliente_razon_social = solicitud.cliente.razon_social
        cliente_contacto = solicitud.contacto.nombre   rescue '-'
        cliente_email    = solicitud.contacto.email    rescue '-'
        cliente_telefono = solicitud.contacto.telefono rescue '-'
        cliente_calle    = servicio.solicitud.cliente.calle_num rescue '--'
        cliente_colonia  = servicio.solicitud.cliente.colonia   rescue '--'
        cliente_ciudad   = servicio.solicitud.cliente.ciudad    rescue '--'
        cliente_estado   = servicio.solicitud.cliente.estado.nombre rescue '--'
        cliente_pais     = servicio.solicitud.cliente.pais.nombre   rescue '--'
        cliente_cp       = servicio.solicitud.cliente.cp            rescue '--'

      bitacoraId = servicio.servicio_bitacora.bitacora_id rescue 0

      muestraId = solicitud.muestras[0].id rescue 0
      detalles = []
      puts "-----------------------------------------------"

      if muestraId > 0
        solicitud.muestras[0].muestra_detalle.each do |detalle|
            detalles << detalle
        end
      end

      puts detalles

      servicio_item = {
          'id'                    => servicio.id,
          'servicio_codigo'       => servicio.codigo,
          'servicio_bitacora_id'  => bitacoraId,
          'nombre'                => servicio.nombre,
          'muestra_id'            => muestraId
      }

      jalar_costeos_bitacora(servicio_item)

      # notificar a Bitacora
      puts "Notificar arranque no coordinado"
      QueueBus.publish('notificar_arranque_no_coordinado',
                        'id'                    => servicio.id,
                        'solicitud_id'          => solicitud.id,
                        'fecha_inicio'          => solicitud.fecha_inicio,
                        'fecha_termino'         => solicitud.fecha_termino,
                        'duracion'              => solicitud.duracion,
                        'tiempo_entrega'        => solicitud.tiempo_text,
                        'agente_id'             => solicitud.usuario.id,
                        'agente_email'          => solicitud.usuario.email,      #  del usuario que da de alta el servicio.
                        'carpeta_codigo'        => solicitud.codigo,
                        'servicio_codigo'       => servicio.codigo,
                        'servicio_bitacora_id'  => bitacoraId,
                        'nombre'                => servicio.nombre,
                        'cliente_id'            => cliente_id,
                        'cliente_nombre'        => cliente_razon_social,
                        'cliente_contacto'      => cliente_contacto,
                        'cliente_email'         => cliente_email,
                        'cliente_telefono'      => cliente_telefono,
                        'cliente_calle'         => cliente_calle,
                        'cliente_colonia'       => cliente_colonia,
                        'cliente_ciudad'        => cliente_ciudad,
                        'cliente_estado'        => cliente_estado,
                        'cliente_pais'          => cliente_pais,
                        'cliente_cp'            => cliente_cp,
                        'vinculacion_hash'      => solicitud.vinculacion_hash,
                        'descripcion'           => solicitud.descripcion,
                        'muestra'               => solicitud.muestras[0],
                        'muestra_detalles'      => detalles
      )
      render json: solicitud
      puts "-----------------------------------------------"
    end

    def notificar_arranque_tipo_2
      solicitud = Solicitud.find(params[:id])
      puts "ARRANQUE TIPO 2"

      muestras = []
      servicios = []

      # Muestras
      solicitud.muestras.each do |muestra|
        muestras_detalle = []
        muestra.muestra_detalle.each do |detalle|
          muestras_detalle << detalle
        end
        muestra_item = {
            'muestra'  => muestra,
            'detalles' => muestras_detalle
        }
        muestras << muestra_item
      end

      solicitud.servicios.where.not(:status => Servicio::CANCELADO).each do |servicio|
        bitacoraId = servicio.servicio_bitacora.bitacora_id rescue 0

        servicio_muestra = ServiciosMuestras.where(servicio_id: servicio.id).first
        muestra = Muestra.find(servicio_muestra.muestra_id)
        muestraId = muestra.id rescue 0

        servicio_item = {
           'id'                    => servicio.id,
           'servicio_codigo'       => servicio.codigo,
           'servicio_bitacora_id'  => bitacoraId,
           'nombre'                => servicio.nombre,
           'muestra_codigo'        => muestra.codigo,
           'muestra_id'            => muestraId,
           'cedula_id'             => servicio.cedula.id
        }
        servicios << servicio_item

        jalar_costeos_bitacora(servicio_item)

      end

        cliente_id = solicitud.cliente_id
        cliente_razon_social = solicitud.cliente.razon_social
        cliente_contacto = solicitud.contacto.nombre   rescue '-'
        cliente_email    = solicitud.contacto.email    rescue '-'
        cliente_telefono = solicitud.contacto.telefono rescue '-'
        cliente_calle    = solicitud.cliente.calle_num rescue '--'
        cliente_colonia  = solicitud.cliente.colonia   rescue '--'
        cliente_ciudad   = solicitud.cliente.ciudad    rescue '--'
        cliente_estado   = solicitud.cliente.estado.nombre rescue '--'
        cliente_pais     = solicitud.cliente.pais.nombre   rescue '--'
        cliente_cp       = solicitud.cliente.cp            rescue '--'

      # notificar a Bitacora
      puts "PUBLICAR EN QUEUE"
      QueueBus.publish('notificar_arranque_tipo_2',
                       'solicitud_id'          => solicitud.id,
                       'agente_id'             => solicitud.usuario.id,
                       'fecha_inicio'          => solicitud.fecha_inicio,
                       'fecha_termino'         => solicitud.fecha_termino,
                       'duracion'              => solicitud.duracion,
                       'tiempo_entrega'        => solicitud.tiempo_text,
                       'agente_email'          => solicitud.usuario.email,      #  del usuario que da de alta el servicio.
                       'responsable_email'     => solicitud.responsable_presupuestal.email,
                       'carpeta_codigo'        => solicitud.codigo,
                       'cliente_id'            => cliente_id,
                       'cliente_nombre'        => cliente_razon_social,
                       'cliente_contacto'      => cliente_contacto,
                       'cliente_email'         => cliente_email,
                       'cliente_telefono'      => cliente_telefono,
                       'cliente_calle'         => cliente_calle,
                       'cliente_colonia'       => cliente_colonia,
                       'cliente_ciudad'        => cliente_ciudad,
                       'cliente_estado'        => cliente_estado,
                       'cliente_pais'          => cliente_pais,
                       'cliente_cp'            => cliente_cp,
                       'vinculacion_hash'      => solicitud.vinculacion_hash,
                       'descripcion'           => solicitud.descripcion,
                       'muestras'              => muestras,
                       'servicios'             => servicios
        )
      puts "PUBLICADO"

      render json: solicitud
    end

    def jalar_costeos_bitacora(servicio_item)

      ## Para tipos I y II
      ## Jala los costeos de la Bitacora dado el Id del Servicio Bitacora
      ## y los inyecta en costeos de vinculacion

      servicio_bitacora_id = servicio_item['servicio_bitacora_id']

      sql = "SELECT id FROM bitacora_production.requested_services WHERE laboratory_service_id = #{servicio_bitacora_id} AND number = 'TEMPLATE';"
      @servicios = ActiveRecord::Base.connection.execute(sql);
      @servicios.each(:as => :hash) do |row|
        puts row
        servicio_id = row["id"]

        costeo = ::Vinculacion::Costeo.new
        costeo.bitacora_id     = servicio_bitacora_id
        costeo.servicio_id     = servicio_item['id']
        costeo.nombre_servicio = servicio_item['nombre']
        costeo.muestra_id      = servicio_item['muestra_id']
        costeo.save


        # personal
        sql = "SELECT * FROM bitacora_production.requested_service_technicians WHERE requested_service_id = #{servicio_id};"
        @technicians = ActiveRecord::Base.connection.execute(sql);
        @technicians.each(:as => :hash) do |row|
          puts row

            userId = row['user_id']
            sql = "SELECT first_name, last_name FROM bitacora_production.users WHERE id = #{userId};"
            empleado = ActiveRecord::Base.connection.exec_query(sql).first
            nombre = empleado['first_name'] + ' ' + empleado['last_name'] rescue "SIN NOMBRE"

            item = costeo.costeo_detalle.new
            item.tipo = 1
            item.descripcion     = nombre
            item.cantidad        = row['hours']
            item.precio_unitario = row['hourly_wage']
            item.save

        end

        # equipos
        sql = "SELECT * FROM bitacora_production.requested_service_equipments WHERE requested_service_id = #{servicio_id};"
        @equipments = ActiveRecord::Base.connection.execute(sql);
        @equipments.each(:as => :hash) do |row|
          puts row

          equipmentId = row['equipment_id']
          sql = "SELECT name FROM bitacora_production.equipment WHERE id = #{equipmentId};"
          equipment = ActiveRecord::Base.connection.exec_query(sql).first
          nombre = equipment['name']

          item = costeo.costeo_detalle.new
          item.tipo = 2
          item.descripcion     = nombre
          item.cantidad        = row['hours']
          item.precio_unitario = row['hourly_rate']
          item.save

        end

        # otros
        sql = "SELECT * FROM bitacora_production.requested_service_others WHERE requested_service_id = #{servicio_id};"
        @others = ActiveRecord::Base.connection.execute(sql);
        @others.each(:as => :hash) do |row|
          puts row

          item = costeo.costeo_detalle.new
          item.tipo = 4
          item.descripcion     = row['concept']
          item.cantidad        = 1
          item.precio_unitario = row['price']
          item.save

        end

      end

    end

    def estimacion_costos_hash
      type      = params[:type]
      solicitud = Solicitud.where(vinculacion_hash: params[:vinculacion_hash]).first
      ## Load locale config
      t = t(:apps)[:vinculacion][:controllers][:cotizaciones][:document]

      pdf_estimacion(solicitud, t)
    end

    def estimacion_costos
      type      = params[:type]
      solicitud = Solicitud.find(params[:id])
      ## Load locale config
      t = t(:apps)[:vinculacion][:controllers][:cotizaciones][:document]
      ## Default Page Size Is Letter
      ## Default Font Is Helvetica

      pdf_estimacion(solicitud, t)
    end

    def pdf_estimacion(solicitud, t)
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
        inicio_title = "#{solicitud.fecha_inicio}"
        termino_title = "#{solicitud.fecha_termino}"
        conclusion_title = "#{solicitud.fecha_termino + 10.days}"

        x = x + 10
        pdf.text_box "Proyecto:", :at=> [x,y -20], :width => 155, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box proyecto_title, :at=> [x + 160,y -20], :width => 400, :height => 13,:valign=> :top, :align => :left, :size=> 12
        y = y - 15
        pdf.text_box "Solicitud:", :at=> [x,y -20], :width => 155, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box solicitud_title, :at=> [x + 160,y -20], :width => 200, :height => 13,:valign=> :top, :align => :left, :size=> 12
        y = y - 15

        pdf.text_box "Inicio servicio:", :at=> [x,y -20], :width => 155, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box inicio_title, :at=> [x + 160,y -20], :width => 200, :height => 13,:valign=> :top, :align => :left, :size=> 12
        y = y - 15
        pdf.text_box "Termino servicio:", :at=> [x,y -20], :width => 155, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box termino_title, :at=> [x + 160,y -20], :width => 200, :height => 13,:valign=> :top, :align => :left, :size=> 12
        y = y - 15
        pdf.text_box "Conclusión administrativa:", :at=> [x,y -20], :width => 155, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box conclusion_title, :at=> [x + 160,y -20], :width => 200, :height => 13,:valign=> :top, :align => :left, :size=> 12
        y = y - 15

        rp = "#{solicitud.responsable_presupuestal.nombre rescue "Sin"} #{solicitud.responsable_presupuestal.apellido_paterno rescue "Asignar"} #{solicitud.responsable_presupuestal.apellido_materno rescue ""}"
        pdf.text_box "Responsable:", :at=> [x,y -20], :width => 95, :height => 13,:valign=> :top, :align => :left, :size=> 12
        pdf.text_box rp, :at=> [x + 160,y -20], :width => 200, :height => 13,:valign=> :top, :align => :left, :size=> 12

        ## RODEAMOS
        y = 560
        pdf.line_width= 0.1
        pdf.stroke_rounded_rectangle([0,y], 500, 96, 10)
        #pdf.stroke_rounded_rectangle([360,y], 145, 80, 10)

        #### PRESUPUESTO PROGRAMADO
        pdf.text "\n\n\n\n\n"
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
        solicitud.servicios.where.not(:status => Servicio::CANCELADO).each do |ss|
          ss.costeos.each do |ssc|
            ssc.costeo_detalle.order(:tipo,:descripcion).each do |ssccd|
              subtotal_consumibles = 0
              subtotal_otros       = 0
              subtotal_hhombre     = 0
              cantidad = ssccd.cantidad

              if ssccd.tipo.to_i.eql? 1 then ## HORAS HOMBRE
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
                      data_consumibles += [["#{ssccd_spaces} #{ssccd.descripcion}",subtotal_consumibles]]
                      break;
                    end
                    counter= counter + 1
                  end
                end
                total_consumibles = total_consumibles + subtotal_consumibles
              elsif ssccd.tipo.to_i.eql? 4 then  #OTROS
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

        ## COLOCANDO SIGNO DE DINERO A CADA UNO
        data_hhombre.each do |dhh|
          dhh[1] = "$#{'%.2f' % dhh[1]}"
        end

        data_consumibles.each do |dc|
          dc[1] = "$#{'%.2f' % dc[1]}"
        end

        data_otros.each do |dot|
          dot[1] = "$#{'%.2f' % dot[1]}"
        end


        title_spaces = "#{Prawn::Text::NBSP * 2}"
        ## INSUMOS
        data += [[ {:content=>"#{title_spaces} <b>Insumos</b> ",:colspan=>2}  ]]
        data += data_consumibles
        data += [[{:content=>"Subtotal #{title_spaces}",:align=>:right}, "$#{'%.2f' % total_consumibles}"]]
        # OTROS
        data += [[ {:content=>"#{title_spaces} <b>Otros</b> ",:colspan=>2}  ]]
        data += data_otros

        suma = total_otros
        if solicitud.tipo != 3
          data += [[{:content=>"Suma #{title_spaces}",:align=>:right}, "$#{'%.2f' % suma}"]]
          # TODO que pasa si hay más de 1 muestra ?
          num_muestras = solicitud.muestras.first.muestra_detalle.size
          data += [[{:content=>"Cantidad muestras #{title_spaces}",:align=>:right}, {:content=>"#{num_muestras}",:align=>:right}]]
          total_otros = suma * num_muestras
        end
        data += [[{:content=>"Subtotal #{title_spaces}",:align=>:right}, {:content=>"$#{'%.2f' % total_otros}",:align=>:right}]]

        tabla = pdf.make_table(data,:width=>497,:cell_style=>{:size=>size - 2,:padding=>3,:border_width=>0.1,:inline_format => true},:column_widths=>[417,80])
        f = data_consumibles.size + 1
        tabla.rows(1..f).column(1).style(:align=> :right)

        i  = data_consumibles.size + 3  #inicial
        f  = data_otros.size       + 3   #final
        tabla.rows(i..f).column(1).style(:align=> :right)
        tabla.draw

        ##  COSTOS INDIRECTOS
        pdf.text "\n"
        pdf.text "Personal", :size=> 15,:style=> :bold
        data = []
        data += [[ {:content=>"#{title_spaces} <b>Horas hombre</b> ",:colspan=>2}  ]]
        data += data_hhombre
        data += [[{:content=>"Subtotal #{title_spaces}",:align=>:right},"$#{'%.2f' % total_hhombre}"]]
        tabla = pdf.make_table(data,:width=>497,:cell_style=>{:size=>size - 2,:padding=>3,:border_width=>0.1,:inline_format => true},:column_widths=>[417,80])
        f  = data_hhombre.size + 1
        tabla.rows(1..f).column(1).style(:align=> :right)
        tabla.draw

        pdf.text "\n"
        ## TOTAL
        data = []
        totale = total_otros+total_consumibles+total_hhombre
        data += [[{:content=>"Total #{title_spaces}",:align=>:left},{:content=>"$#{'%.2f' % totale}",:align=>:right}]]
        tabla = pdf.make_table(data,:width=>200,:cell_style=>{:size=>size - 2,:padding=>3,:border_width=>0.1,:inline_format => true},:column_widths=>[120,80],:position=>:right)
        tabla.draw


        ### ENVIANDO EL PDF
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end

    def recepcion_muestras
      blank_sheet = false
      solicitud = Solicitud.find(params[:id])
      t = t(:apps)[:vinculacion][:controllers][:cotizaciones][:document]
      Prawn::Document.new(:top_margin => 50.0, :bottom_margin=> 100.0, :left_margin=>70.0, :right_margin=>45.0) do |pdf|
        image = "#{Rails.root}/private/images/logo_cimav_100.png" 
        pdf.image image, :position => :left, :height => 50
        x = 100
        y = 635
        w = 350
        h = 28
        size = 11
        pdf.text_box t[:center], :at=> [x,y], :width => w, :height => h,  :valign=> :top, :align => :left, :size=> 13
        
        ## DIRECCIONES
        y = y - 15
        h = 40
        pdf.text_box t[:address0], :at=> [x,y], :width => w, :height => h,:valign=> :top, :align => :left, :size=> 5
        x = x + 110
        pdf.text_box t[:address1], :at=> [x,y], :width => w, :height => h,:valign=> :top, :align => :left, :size=> 5
        x = x + 90
        pdf.text_box t[:address2], :at=> [x,y], :width => w, :height => h,:valign=> :top, :align => :left, :size=> 5
        
        ## LINE
        x = 0
        y = y - 43 
        pdf.stroke_color= "000000"
        pdf.line_width= 3
        pdf.stroke_line [x,y],[245,y]
        pdf.line_width= 1
        pdf.stroke_line [x,y - 3],[245,y - 3]
        pdf.text_box "RESGUARDO DE MUESTRAS Y/O EQUIPOS", :at=> [250,y + 3 ], :width => 230, :style => :bold_italic, :height => 13, :valign=> :top, :align => :center, :size=> 11
        pdf.line_width= 3
        pdf.stroke_line [485,y],[505,y]
        pdf.line_width= 1
        pdf.stroke_line [485,y - 3],[505,y - 3]

        ## FECHA 
        tday  = Date.today
        dia   = tday.day
        mes   = t(:date)[:month_names][tday.month]
        anyo  = solicitud.fecha_inicio.year
        ## CALCULANDO FOLIO
        anyof        = anyo.to_s[2,4]
        con          = solicitud.consecutivo
        c_solicitud  = solicitud.codigo

        if blank_sheet
          folio = "00/0000"
          fecha = "[fecha]"
        else
          folio        = c_solicitud
          fecha        = "#{dia} de #{mes} del #{anyo}"
        end

        pdf.text "\n\n\n"
        pdf.text_box folio,    :at=> [380,y - 25], :width => 100, :height => 30,:valign=> :top, :align => :center, :size=> 15, :style=> :bold
        pdf.text_box fecha,    :at=> [380,y - 43], :width => 100, :height => 30,:valign=> :top, :align => :center, :size=> 9
        
        ## DATOS GENERALES

        cliente_razon_social = ""
        contacto_nombre = ""
        cliente_calle_num = ""
        cliente_colonia = ""
        cliente_cp = ""
        contacto_telefono = ""
        contacto_email = ""

          cliente              = solicitud.cliente
          cliente_razon_social = cliente.razon_social rescue ''
          cliente_calle_num    = cliente.calle_num rescue ''
          cliente_colonia      = cliente.colonia rescue ''
          cliente_cp           = cliente.cp rescue ''
          if cliente_cp != ''
            cliente_cp= "C.P. #{cliente_cp}"
          end
          contacto             = solicitud.contacto
          contacto_nombre      = contacto.nombre rescue ''
          contacto_telefono    = contacto.telefono rescue ''
          contacto_email       = contacto.email.downcase rescue ''

        data = [ [t[:company],         cliente_razon_social],
                 [t[:attention],       contacto_nombre],
                 [t[:company_address], "#{cliente_calle_num} #{cliente_colonia} #{cliente_cp}"],
                 [t[:phone],           contacto_telefono],
                 [t[:email],           contacto_email]]
        x = 15
        y = y - 25
        data.each do |d|
          pdf.text_box d[0], :at=> [x,y], :width => 50, :height => 11,:valign=> :top, :align => :left, :size=> 10
          if d[1]
            pdf.text_box d[1], :at=> [x + 50,y], :width => 200, :height => 11,:valign=> :top, :align => :left, :size=> 10
          end
          y = y - 10
        end

        ## RODEAMOS
        y = 560
        pdf.line_width= 0.1
        pdf.stroke_rounded_rectangle([0,y], 350, 80, 10)
        pdf.stroke_rounded_rectangle([360,y], 145, 80, 10)

        pdf.text "\n\n\n\n\n\n"
        
        data=[
          [{:content=>"Descripción del instrumento de medición y/o muestras",:colspan=>2,:align=>:center,:size=>size + 2}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
          ["",{:content=>"____Integro  ____Con Anomalía",:size=>size - 4,:align=>:center}],
         ]
        tabla = pdf.make_table(data,:header=>false,:width=>505,:column_widths=>[395,110],:cell_style=>{:padding=>4,:border_width=>0.5})
        tabla.draw       
        pdf.text "\n\n"
        pdf.text "* La revisión del equipo solo es visual, cualquier anomalia de funcionamiento se detectará por el laboratorio.\n * Resguardo, a las instalaciones del CIMAV, localizadas en Miguel de Cervantes N° 120, Complejo Industrial Chihuahua, Chih.\n * El CIMAV solo mantendrá en resguardo las muestras en un periodo máximo de cinco días contados a partir de finalizado el servicio de laboratorio solicitado por la Empresa; posteriormente dichas muestras serán destruidas.\n * En el caso de que la muestra sea enviada a confinamiento por medidas de seguridad, los gastos en que se incurra serán cubiertos por la empresa o persona que requiera los servicios de laboratorio CIMAV.\n ",:align=>:justify,:size=>7
        pdf.text "\n\n\n"
        pdf.text "_________________________",:align=>:center
        pdf.text "Firma del Cliente",:align=>:center
       # pdf.stroke_line [0,-45],[500,-45]
        pdf.text_box "VN01F06-02", :at=> [427,-45], :width => 70, :height => 12,:valign=> :top, :align => :left, :size=> 12
        
        h = 90 
        w = 225
        pdf.text_box t[:responsable], :at=>[0,33], :width => w, :height=> h, :size=>12, :align=> :left, :valign=> :bottom
        
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
