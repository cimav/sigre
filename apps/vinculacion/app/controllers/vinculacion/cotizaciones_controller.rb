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
        pdf.text_box "COTIZACION", :at=> [401,y + 3 ], :width => 80, :style => :bold_italic, :height => 13, :valign=> :top, :align => :center, :size=> 11
        pdf.line_width= 3
        pdf.stroke_line [485,y],[505,y]
        pdf.line_width= 1
        pdf.stroke_line [485,y - 3],[505,y - 3]
        
     
        ## FECHA 
        dia   = cotizacion.fecha_notificacion.day
        mes   = t(:date)[:month_names][cotizacion.fecha_notificacion.month]
        anyo  = cotizacion.fecha_notificacion.year
        ## CALCULANDO FOLIO
        anyof       = anyo.to_s[2,4]
        con         = cotizacion.solicitud.consecutivo
        c_solicitud = "%03d" % con.to_i
        c_cotizacion = cotizacion.consecutivo
        folio = "#{anyof}#{c_solicitud}-#{c_cotizacion}"
        fecha = "#{dia} de #{mes} del #{anyo}"
        t_cambio = "Tipo de Cambio: M.N. Pesos"
        pdf.text "\n\n\n"
        pdf.text_box folio,    :at=> [380,y - 25], :width => 100, :height => 30,:valign=> :top, :align => :center, :size=> 15, :style=> :bold
        pdf.text_box fecha,    :at=> [370,y - 45], :width => 100, :height => 30,:valign=> :top, :align => :left, :size=> 9
        pdf.text_box t_cambio, :at=> [370,y - 61], :width => 135, :height => 30,:valign=> :top, :align => :left, :size=> 9

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
        leyenda = "En respuesta a su solicitud de #{analisis} y agradeciendo su preferencia, ponemos a su consideración la siguiente propuesta económica:"
        pdf.text leyenda, :size=> 9

        ## CABECERA
        data = [[t[:amount],t[:description],t[:unit_cost], t[:subtotal]]]
        ## REITERATIVOS
        counter   = 0
        subtotalf = 0
        cotizacion.cotizacion_detalle.each do |cd|
          subtotal = cd.precio_unitario * cd.cantidad
          r = [[cd.cantidad,cd.concepto,cd.precio_unitario.to_s,subtotal.to_s]]
          data += r
          counter = counter + 1
          subtotalf += subtotal
        end

        ## Descomentar para desarrollo, comentar el ciclo de arriba
        #40.times do |cd|
          #subtotal = 0
          #r = [["1","cosa #{counter}","100","100"]]
          #data += r
          #counter = counter + 1
          #subtotalf += subtotal
        #end

        ## CALCULANDO EL IVA
        iva = (subtotalf * cotizacion.iva)/100

        ## SUBTOTALES
        data +=[["","",t[:subtotal],subtotalf],["","","Iva",iva],["","","Total",(subtotalf + iva).to_s]]
        pdf.table(data,:header=> true,:width=>505,:column_widths=>[50,255,100,100],:cell_style=> {:align=>:center,:valign=>:center,:size=>size - 2,:padding=>3,:border_width=>0.1}) do
          row(0).border_width = 0.1
          rows(1..counter).columns(0..3).borders = [:left,:right]
          row(counter + 1).column(0..2).style(:borders=>[:top])
          row(counter + 2).column(0..2).style(:borders=>[])
          row(counter + 3).column(0..2).style(:borders=>[])
        end

        pdf.text "\n"
        #OBSERVACIONES


       # data = [[t[:legal],t[:observacion]]]
        notes = cotizacion.notas
        data = [[t[:legal],notes]]
        pdf.table(data,:header=> false,:width=>505, :column_widths=>[405,100], :cell_style=> {:align=>:left,:valign=>:top,:padding=>3,:borders=>[]}) do
          row(0).column(0).style(:size=> size - 4,:inline_format=>true)
          row(0).column(1).style(:borders=>[:top,:bottom,:left,:right],:size=> size - 3)
            
        end

        pdf.text "\n\n"
        pdf.text "Notas:
- Esta cotización tiene una vigencia de 30 días hábiles.
- La programación de la medición es 8 días hábiles posteriores a la recepción del comprobante de pago, el tiempo de entrega del informe de resultados es 30 días naturales.
- Se consideran días hábiles de lunes a viernes en un horario de 9:00 -14:00 y 16:00 -19:00 h.
- El cliente aprueba el procedimiento técnico y la realización de las pruebas o calibraciónes en su material o equipo al autorizar el servicio.
- En caso de autorizar el servicio, deberá hacernos llegar mediante este mismo medio la orden de trabajo que autorice los estudios a realizar y los materiales e información técnica de los mismos.
- Si no se encuentra registrado en nuestro catalogó de cliente deberá pagar el costo del servicio para poder comenzar con el mismo,  a la cuenta Banorte 0127370266 clabe 072150001273702669
- Una vez finalizado el servicio, el cliente cuenta con 30 días para recoger sus muestras; transcurrido este tiempo se desechan.
- Para los servicios de calibración, si en un período preliminar de calibración el LABORATORIO DE METROLOGÍA observa que el instrumento está dañado se suspenderá el proceso de calibración, se le notificará  al cliente. Se entenderá que la  calibración solicitada ya no se efectuará. Queda establecido que el LABORATORIO DE METROLOGÍA no será responsable de los equipos que se hayan presentado dañados, con vicios ocultos o cualquier irregularidad. La fecha de entrega del instrumento aplica siempre y cuando el instrumento no requiera ajustes, ya que en este último caso (si se cuenta con todo lo necesario para llevar a cabo el ajuste), el tiempo puede extenderse. Si al instrumento le falta algún aditamento para realizar la calibración la fecha de recepción comenzará a contar a partir de que dicho elemento sea entregado al laboratorio. La recolección del instrumento en las instalaciones del laboratorio corre a cargo del cliente, excepto cuando se haya estipulado en la cotización su envío por mensajería.. El servicio de calibración no incluye ajuste o reparación de los instrumentos. Si se requiere la verificación de los resultados contra una tolerancia específica, ésta debe ser proporcionada por el solicitante. El informe de calibración se emitirá independientemente de que el instrumento no cumpla con la norma de referencia o especificaciones de tolerancias dadas. El  cliente puede definir cómo se expresarán los resultados (en que unidades, etc.), de no hacerlo, el LABORATORIO DE METROLOGÍA expresará los resultados según lo marque el procedimiento de calibración utilizado. (8). El cliente podrá especificar los puntos en los cuáles se calibrará el instrumento, de no hacerlo, el LABORATORIO DE METROLOGÍA escogerá los puntos según lo marque el procedimiento de calibración utilizado. Para su calibración los instrumentos deberán ser entregados en buenas condiciones de funcionamiento y limpios. En caso contrario no se realizará el servicio. El cliente proporcionará la información necesaria y dará todas las facilidades para el desarrollo del servicio. Para servicios de calibración, el LABORATORIO DE METROLOGÍA únicamente garantiza que el equipo del solicitante funciona en el lugar que se efectuó la calibración ya que durante el traslado a su lugar de origen cualquier movimiento brusco o falta de cuidado del transportador puede afectar la calibración.",
:size=>7


        # NOTAS
        pdf.text "\n"
      #  pdf.text cotizacion.notas,:size=>size
        ## FOOTER
        y = -35
        pdf.repeat :all do
          ## Firmas
          w= (pdf.bounds.width / 2) + 10
          h= 15
          x= 0
          pdf.fill_color "e6e6e6"
          pdf.fill_rectangle [x,y + 25], w, h
          pdf.fill_color "000000"
          pdf.text_box "Elaboró CIMAV:", :at=>[x,y + 25], :width => w, :height=> h, :size=>9, :align=> :left, :valign=> :center

          h= 15
          x= x + (pdf.bounds.width / 2)
          pdf.fill_color "e6e6e6"
          pdf.fill_rectangle [x,y + 25], w, h
          pdf.fill_color "000000"
          pdf.text_box "Aceptó Cliente:", :at=>[x,y + 25], :width => w, :height=> h, :size=>9, :align=> :left, :valign=> :center

          ## USUARIO
          x = 0
          y1 = y + 3
          w = 100
          h = 10
          pdf.text_box "[usuario]", :at=>[x,y1], :width => w, :height=> h, :size=>9, :align=> :left, :valign=> :bottom
        
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
          x = pdf.bounds.width - w
          y_v = y -20
          pdf.text_box t[:version], :at=>[x,y_v], :width => w, :height=> h, :size=>11, :align=> :center, :valign=> :bottom
        end
        
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
          :duracion
      )
    end
  end
end

