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
        pdf.stroke_line [x,y],[400,y]
        pdf.line_width= 1
        pdf.stroke_line [x,y - 3],[400,y - 3]
        pdf.text_box "COTIZACIÓN", :at=> [401,y + 3 ], :width => 80, :style => :bold_italic, :height => 13, :valign=> :top, :align => :center, :size=> 11
        pdf.line_width= 3
        pdf.stroke_line [485,y],[505,y]
        pdf.line_width= 1
        pdf.stroke_line [485,y - 3],[505,y - 3]
        
     
        ## FECHA 
        dia   = cotizacion.fecha_notificacion.day
        mes   = t(:date)[:month_names][cotizacion.fecha_notificacion.month]
        anyo  = cotizacion.fecha_notificacion.year
        ## CALCULANDO FOLIO
        anyof        = anyo.to_s[2,4]
        con          = cotizacion.solicitud.consecutivo
        c_solicitud  = "%04d" % con.to_i
        c_cotizacion = cotizacion.consecutivo
        folio        = "#{anyof}/#{c_solicitud}-#{c_cotizacion}"
        fecha        = "#{dia} de #{mes} del #{anyo}"
        coin         = Moneda.find(cotizacion.divisa) rescue ""
        t_cambio     = "Tipo de cambio: #{coin.codigo} (#{coin.nombre})"
        t_entrega    = ""
        if cotizacion.tiempo_entrega.eql? 2
          t_entrega    = "Urgente" 
        elsif cotizacion.tiempo_entrega.eql? 3
          t_entrega    = "Express" 
        end
        
        pdf.text "\n\n\n"
        pdf.text_box folio,    :at=> [380,y - 25], :width => 100, :height => 30,:valign=> :top, :align => :center, :size=> 15, :style=> :bold
        pdf.text_box fecha,    :at=> [366,y - 43], :width => 100, :height => 30,:valign=> :top, :align => :left, :size=> 9
        pdf.text_box t_cambio, :at=> [366,y - 56], :width => 135, :height => 30,:valign=> :top, :align => :left, :size=> 9
        pdf.text_box t_entrega,:at=> [380,y - 80], :width => 100, :height => 30,:valign=> :top, :align => :center, :size=> 9

        ## DATOS GENERALES
        cliente  = cotizacion.solicitud.cliente      
        contacto = cotizacion.solicitud.contacto
 
        contacto_nombre = contacto.nombre rescue 'Sin contacto'
        contacto_telefono = contacto.telefono rescue 'Sin contacto'
        contacto_email = contacto.email rescue 'Sin contacto'
    
        data = [ [t[:company],         cliente.razon_social],
                 [t[:attention],       contacto_nombre],
                 [t[:company_address], "#{cliente.calle_num} #{cliente.colonia} C.P. #{cliente.cp}"],
                 [t[:phone],           contacto_telefono],
                 [t[:email],           contacto_email],
                 [t[:rfc],             cliente.rfc]]
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

        ## ALGUNOS SALTOS DE LINEA PARA BAJAR LA TABLA
        pdf.text "\n\n\n\n\n\n"

        analisis = cotizacion.solicitud.descripcion rescue "desarrollo de servicio"
        analisis = analisis.length <= 0 ? "desarrollo de servicio" : analisis
        leyenda  = cotizacion.comentarios
        #leyenda = "En respuesta a su solicitud de #{analisis} y agradeciendo su preferencia, ponemos a su consideración la siguiente propuesta económica:"
        pdf.text leyenda, :size=> 9

        ## CABECERA
        data = [[t[:amount],t[:description],t[:unit_cost], t[:subtotal]]]
        ## REITERATIVOS
        counter   = 0
        subtotalf = 0

        cotizacion.cotizacion_detalle.each do |cd|
          subtotal = cd.precio_unitario * cd.cantidad
          r = [[cd.cantidad,cd.concepto,"$#{cd.precio_unitario.to_s}","$#{subtotal.to_s}"]]
          data += r
          counter = counter + 1
          subtotalf += subtotal
        end

        ## Descomentar para desarrollo, comentar el ciclo de arriba
=begin
        15.times do |cd|
          subtotal = 0
          r = [["1","cosa #{counter}","$100.00","$100.00"]]
          data += r
          counter = counter + 1
          subtotalf += subtotal
        end
=end

        ## CALCULANDO EL IVA
        iva = (subtotalf * cotizacion.iva)/100

        ## SUBTOTALES
        data +=[["","",t[:subtotal],"$#{subtotalf}"],["","","Iva","$#{iva}"],["","","Total","$#{(subtotalf + iva).to_s}"]]
        pdf.table(data,:header=> true,:width=>505,:column_widths=>[50,255,100,100],:cell_style=> {:valign=>:center,:size=>size - 2,:padding=>3,:border_width=>0.5}) do
          rows(1..counter).columns(0..3).borders = [:left,:right,:bottom]
          rows(1..counter).border_bottom_width= 0.1
          row(counter + 1).column(0..2).style(:borders=>[:top])
          row(counter + 2).column(0..2).style(:borders=>[])
          row(counter + 3).column(0..2).style(:borders=>[])
          column(0).style :align=>:center
          column(2..3).style :align=>:right
        end

        pdf.text "\n\n"
        #OBSERVACIONES
        x = 0
        y = 420
        a = 360
        b = 60
        #pdf.bounding_box([x,y], :width=>a, :height=>b) do
        #  pdf.stroke_color '000000'
        #  pdf.stroke_bounds
        #end
        pdf.text_box t[:legal], :at=>[x,y], :width=>a, :height=>b, :align=>:justify, :valign=>:center, :inline_format=>true, :size=> size - 5
        c_notas = nil
        cotizacion.notas.split("\n").each do |n|
          if !n.empty?
            c_notas = "#{c_notas} - #{n}\n"
          end
        end

        pdf.text "Notas:
- Esta cotización tiene una vigencia de 30 días hábiles.\n#{c_notas}- Se consideran días hábiles de lunes a viernes en un horario de 9:00 -14:00 y 16:00 -19:00 h.\n- El cliente aprueba el procedimiento técnico y la realización de las pruebas o calibraciónes en su material o equipo al autorizar el servicio.\n- En caso de autorizar el servicio, deberá hacernos llegar mediante este mismo medio la orden de trabajo que autorice los estudios a realizar y los materiales e información técnica de los mismos.\n- Si no se encuentra registrado en nuestro catálogo de cliente deberá pagar el costo del servicio para poder comenzar con el mismo,  a la cuenta Banorte 0127370266 clabe 072150001273702669 si el servicio corresponde a CIMAV Chihuahua y a la cuenta BANORTE 0252602458 clabe 072 150 00252602458 5 para servicios de CIMAV Monterrey.\n- Una vez finalizado el servicio, el cliente cuenta con 30 días para recoger sus muestras; transcurrido este tiempo se desechan.\n- Para los servicios de calibración, si en un período preliminar de calibración el LABORATORIO DE METROLOGÍA observa que el instrumento está dañado se suspenderá el proceso de calibración, se le notificará  al cliente. Se entenderá que la  calibración solicitada ya no se efectuará. Queda establecido que el LABORATORIO DE METROLOGÍA no será responsable de los equipos que se hayan presentado dañados, con vicios ocultos o cualquier irregularidad. La fecha de entrega del instrumento aplica siempre y cuando el instrumento no requiera ajustes, ya que en este último caso (si se cuenta con todo lo necesario para llevar a cabo el ajuste), el tiempo puede extenderse. Si al instrumento le falta algún aditamento para realizar la calibración la fecha de recepción comenzará a contar a partir de que dicho elemento sea entregado al laboratorio. La recolección del instrumento en las instalaciones del laboratorio corre a cargo del cliente, excepto cuando se haya estipulado en la cotización su envío por mensajería.. El servicio de calibración no incluye ajuste o reparación de los instrumentos. Si se requiere la verificación de los resultados contra una tolerancia específica, ésta debe ser proporcionada por el solicitante. El informe de calibración se emitirá independientemente de que el instrumento no cumpla con la norma de referencia o especificaciones de tolerancias dadas. El  cliente puede definir cómo se expresarán los resultados (en que unidades, etc.), de no hacerlo, el LABORATORIO DE METROLOGÍA expresará los resultados según lo marque el procedimiento de calibración utilizado. (8). El cliente podrá especificar los puntos en los cuáles se calibrará el instrumento, de no hacerlo, el LABORATORIO DE METROLOGÍA escogerá los puntos según lo marque el procedimiento de calibración utilizado. Para su calibración los instrumentos deberán ser entregados en buenas condiciones de funcionamiento y limpios. En caso contrario no se realizará el servicio. El cliente proporcionará la información necesaria y dará todas las facilidades para el desarrollo del servicio. Para servicios de calibración, el LABORATORIO DE METROLOGÍA únicamente garantiza que el equipo del solicitante funciona en el lugar que se efectuó la calibración ya que durante el traslado a su lugar de origen cualquier movimiento brusco o falta de cuidado del transportador puede afectar la calibración.\n",:align=>:justify,:size=>7
        pdf.text "\n"
        ## FOOTER
        y = -35
          ## Firmas
          w= (pdf.bounds.width / 2) + 10
          h= 15
          x= 0
          pdf.fill_color "e6e6e6"
          pdf.fill_rectangle [x,y + 45], w, h
          pdf.fill_color "000000"
          pdf.text_box "Elaboró CIMAV:", :at=>[x,y + 45], :width => w, :height=> h, :size=>9, :align=> :left, :valign=> :center

          h= 15
          x= x + (pdf.bounds.width / 2)
          pdf.fill_color "e6e6e6"
          pdf.fill_rectangle [x,y + 45], w, h
          pdf.fill_color "000000"
          pdf.text_box "Aceptó Cliente:", :at=>[x,y + 45], :width => w, :height=> h, :size=>9, :align=> :left, :valign=> :center

          ## USUARIO
          x = 0
          y1 = y + 30
          w = 350
          h = 10
          full_name = "#{current_user.nombre} #{current_user.apellidos}"
          pdf.text_box full_name, :at=>[x,y1], :width => w, :height=> h, :size=>9, :align=> :left, :valign=> :bottom
        
          ## LINE 2
          x = 0
          y2 = y - 8
          pdf.stroke_color= "000000"
          pdf.line_width= 3
          pdf.stroke_line [x,y2],[505,y2]
          pdf.line_width= 1
          pdf.stroke_line [x,y2 - 3],[505,y2 - 3]

          ## Texto de Agradecimiento
          w= 300
          h= 17
          x= (pdf.bounds.width / 2)- (w/2)
          y3= y - 15          
          pdf.fill_color "e6e6e6"
          pdf.fill_rectangle [x,y3], w, h
          pdf.fill_color "000000"
          pdf.text_box t[:gratitude], :at=>[x,y3], :width => w, :height=> h, :size=>9, :align=> :center, :valign=> :center, :style=>:italic

          ## VERSION DOCUMENTO
          w = 90
          h = 12
          pdf.text_box t[:version], :at=>[0,y+5], :width => w, :height=> h, :size=>11, :align=> :left, :valign=> :bottom
        
       # pdf.repeat :all do
       # end
        
        #NUM. PAGINA
        x = pdf.bounds.left
        y4 = y - 40
        pdf.number_pages "<page>/<total>",  {:at => [x,y4],
                                            :align => :center,
                                            :size => 11}

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
          :status,
          :msg_notificacion,
          :motivo_status,
          :motivo_descuento,
          :duracion,
          :tiempo_entrega
      )
    end
  end
end

