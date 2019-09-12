# encoding: utf-8
require_dependency "vinculacion/application_controller"

module Vinculacion
  class CotizacionesController < ApplicationController

    skip_before_filter :auth_required, :only => :download_document

    def index
      results = Cotizacion.where(:solicitud_id => params[:solicitud_id])
      render json: results
    end

    def descuento_solicitado
      cotizas = Cotizacion.where(:status => Cotizacion::STATUS_DESCUENTO_SOLICITADO).where("descuento_porcentaje > 0").order("tiempo_entrega desc")
      customJson = '{"cotizaciones":['
      cotizas.each do |cotiza|

        id_cot = cotiza.id.to_s
        sol = cotiza.solicitud
        codigo = cotiza.codigo
        descuento = cotiza.descuento_porcentaje.to_s
        cli = sol.cliente.razon_social rescue 'Sin razon social'
        tiempo_entr = cotiza.tiempo_entrega.to_s
        divisa = cotiza.divisa.to_s
        motivo = cotiza.motivo_descuento.to_s
        subtotal = cotiza.subtotal.to_s
        descripcion = sol.descripcion.nil? ? 'Sin descripcion' :(sol.descripcion)

        # Construccion de la cadena
        cadena = '{"id":' + id_cot + ', "codigo":"' + codigo + '", "cliente":"' + cli +
            '", "descuento_porcentaje":' + descuento +  ', "tiempo_entrega":' + tiempo_entr +
            ', "divisa":' + divisa +', "motivo_descuento":"' + motivo + '", "subtotal":' + subtotal +
            ', "descripcion":"' + descripcion + '"}'
        # Estructurando el json
        customJson = customJson + cadena
      end
      customJson = customJson + ']}'
      customJson = customJson.gsub("}{","},{")
      render json: customJson
    end

    def descuento_aceptar
      cotizacion = Cotizacion.find(params[:id]) rescue nil
      if !cotizacion.nil? && cotizacion.status == Cotizacion::STATUS_DESCUENTO_SOLICITADO
        Cotizacion.update(cotizacion.id,
                          :status => Cotizacion::STATUS_DESCUENTO_ACEPTADO,
                          :descuento_porcentaje => params[:descuento_porcentaje],
                          :motivo_descuento => params[:motivo_descuento])
        render text: 'Solicitud aceptada'
      else
        render text:'No se encuentra la solicitud de descuento'
      end
    end

    def descuento_rechazar
      cotizacion = Cotizacion.find(params[:id]) rescue nil
      if !cotizacion.nil? && cotizacion.status == Cotizacion::STATUS_DESCUENTO_SOLICITADO
        Cotizacion.update(cotizacion.id,
                          :status => Cotizacion::STATUS_DESCUENTO_RECHAZADO,
                          :motivo_descuento =>  params[:motivo_descuento])
        render text: 'Solicitud rechazada'
      else
        render text:'No se encuentra la solicitud de descuento'
      end
    end

    def show
      render json: Cotizacion.find(params[:id])
    end

    def create
      params[:cotizacion]['msg_notificacion'] = "Estimado cliente, se adjunta cotización solicitada.
      
Saludos.

(Favor de NO contestar a esta dirección de correo electrónico)
"
      render json: Cotizacion.create(cotizacion)
    end

    def update
      puts "UPDATE"
      if params[:cotizacion][:status] == Cotizacion::STATUS_NOTIFICADO
        c = Cotizacion.find(params[:id])
        pdf = create_document(params[:id])

        filename = c.solicitud.codigo.gsub('/', '_').concat('.pdf')
        puts "ARCHIVO"
        puts filename
        pdf.render_file File.join(Rails.root.to_s, "private/cotizaciones", filename)
        puts "************************************"
        puts "PDF Guardado"
        puts "************************************"
        if c.solicitud.proyecto_id == 1
          VinculacionMailer.enviar_cotizacion(c.solicitud_id, c.id, current_user.email, params[:cotizacion][:msg_notificacion]).deliver 
        end
      end
      render json: Cotizacion.find(params[:id]).tap { |b| b.update_attributes(cotizacion) }
    end

    def destroy
      render json: Cotizacion.find(params[:id]).destroy
    end

    def create_document(id)
      r_root = Rails.root.to_s
      type = params[:type]
      blank_sheet = false
      cotizacion = Cotizacion.find(id)
      ## Load locale config
      t = t(:apps)[:vinculacion][:controllers][:cotizaciones][:document]
      ## Default Page Size Is Letter
      ## Default Font Is Helvetica
      Prawn::Document.new(:top_margin => 50.0, :bottom_margin=> 100.0, :left_margin=>70.0, :right_margin=>45.0) do |pdf|
        image = "#{Rails.root}/private/images/logo_cimav_100.png"
        pdf.image image, :position => :left, :height => 50

        pdf.font_families.update("Arial" => {
            :bold => "#{r_root}/private/fonts/arial/arialbd.ttf",
            :italic => "#{r_root}/private/fonts/arial/ariali.ttf",
            :bold_italic => "#{r_root}/private/fonts/arial/arialbi.ttf",
            :normal => "#{r_root}/private/fonts/arial/arial.ttf"
        })
        pdf.font "Arial"

        x = 100
        y = 635 #640
        w = 350
        h = 28
        size = 11
        pdf.text_box t[:center], :at => [x, y], :width => w, :height => h, :valign => :top, :align => :left, :size => 13


        ## DIRECCIONES
        y = y - 15 #30
        h = 40
        pdf.text_box t[:address0], :at => [x, y], :width => w, :height => h, :valign => :top, :align => :left, :size => 5
        x = x + 110
        pdf.text_box t[:address1], :at => [x, y], :width => w, :height => h, :valign => :top, :align => :left, :size => 5
        x = x + 90
        pdf.text_box t[:address2], :at => [x, y], :width => w, :height => h, :valign => :top, :align => :left, :size => 5

        ## LINE
        x = 0
        y = y - 47
        pdf.stroke_color= "000000"
        pdf.line_width= 3
        pdf.stroke_line [x, y], [400, y]
        pdf.line_width= 1
        pdf.stroke_line [x, y - 3], [400, y - 3]
        pdf.text_box "COTIZACIÓN", :at => [401, y + 3], :width => 80, :style => :bold_italic, :height => 13, :valign => :top, :align => :center, :size => 11
        pdf.line_width= 3
        pdf.stroke_line [485, y], [505, y]
        pdf.line_width= 1
        pdf.stroke_line [485, y - 3], [505, y - 3]

        ## FECHA 
        dia = cotizacion.fecha_notificacion.day
        mes = t(:date)[:month_names][cotizacion.fecha_notificacion.month]
        anyo = cotizacion.fecha_notificacion.year
        c_cotizacion = cotizacion.consecutivo
        folio = "#{cotizacion.solicitud.codigo}-#{c_cotizacion}"
        fecha = "#{dia} de #{mes} del #{anyo}"
        coin = Moneda.find(cotizacion.divisa) rescue ""
        t_cambio = "Tipo de cambio: #{coin.codigo} (#{coin.nombre})"
        t_entrega = ""
        if cotizacion.tiempo_entrega.eql? 2
          t_entrega = "Urgente"
        elsif cotizacion.tiempo_entrega.eql? 3
          t_entrega = "Express"
        end

        pdf.text "\n\n\n"
        if blank_sheet
          pdf.text_box "00/0000", :at => [380, y - 25], :width => 100, :height => 30, :valign => :top, :align => :center, :size => 15, :style => :bold
          pdf.text_box "", :at => [366, y - 43], :width => 100, :height => 30, :valign => :top, :align => :left, :size => 9
          pdf.text_box "Tipo de cambio: ", :at => [366, y - 56], :width => 135, :height => 30, :valign => :top, :align => :left, :size => 9
          pdf.text_box "", :at => [380, y - 80], :width => 100, :height => 30, :valign => :top, :align => :center, :size => 9
        else
          pdf.text_box folio, :at => [380, y - 25], :width => 100, :height => 30, :valign => :top, :align => :center, :size => 15, :style => :bold
          pdf.text_box fecha, :at => [366, y - 43], :width => 135, :height => 30, :valign => :top, :align => :left, :size => 9
          pdf.text_box t_cambio, :at => [366, y - 56], :width => 135, :height => 30, :valign => :top, :align => :left, :size => 9
          pdf.text_box t_entrega, :at => [380, y - 80], :width => 100, :height => 30, :valign => :top, :align => :center, :size => 9
        end

        ## DATOS GENERALES

        cliente_razon_social = ""
        contacto_nombre = ""
        cliente_calle_num = ""
        cliente_colonia_cp = ""
        contacto_telefono = ""
        contacto_email = ""

        cliente = cotizacion.solicitud.cliente
        contacto = cotizacion.solicitud.contacto

        cliente_razon_social = cliente.razon_social
        contacto_nombre = contacto.nombre rescue 'Sin contacto'
        cliente_calle_num = "#{cliente.calle_num}"
        cliente_colonia_cp = "#{cliente.colonia} C.P. #{cliente.cp}"
        contacto_telefono = contacto.telefono rescue 'Sin contacto'
        contacto_email = contacto.email.downcase rescue 'Sin contacto'

        #cliente_rfc       = cliente.rfc.upcase rescue 'N.D'

        data = [[t[:company], cliente_razon_social],
                [t[:attention], contacto_nombre],
                [t[:company_address], cliente_calle_num],
                [t[:company_address2], cliente_colonia_cp],
                [t[:phone], contacto_telefono],
                [t[:email], contacto_email]]
        x = 15
        y = y - 20
        i = 0
        data.each do |d|
          if d[0]
            pdf.text_box d[0], :at => [x, y], :width => 50, :height => 11, :valign => :top, :align => :left, :size => 10
          end

          if i.eql? 3
            h = 22
          else
            h = 11
          end

          if d[1]
            pdf.text_box d[1], :at => [x + 50, y], :width => 280, :height => h, :valign => :top, :align => :left, :size => 10
          end

          if i.eql? 3
            y = y - 24
          else
            y = y - 12
          end

          i = i + 1
        end

        ## RODEAMOS
        y = 560
        pdf.line_width= 0.1
        pdf.stroke_rounded_rectangle([0, y], 350, 92, 10)
        pdf.stroke_rounded_rectangle([360, y], 145, 92, 10)

        ## ALGUNOS SALTOS DE LINEA PARA BAJAR LA TABLA
        pdf.text "\n\n\n\n\n\n\n"

        analisis = cotizacion.solicitud.descripcion rescue "desarrollo de servicio"
        analisis = (analisis.length <= 0 ? "desarrollo de servicio" : analisis) rescue "desarrollo de servicio"
        leyenda = cotizacion.comentarios
        if blank_sheet
          pdf.text "En respuesta a su solicitud para ...", :size => 9
        else
          pdf.text leyenda, :size => 9
        end

        ## CABECERA
        data = [[t[:quantity], t[:description], t[:unit_cost], t[:amount]]]
        ## REITERATIVOS
        counter = 0
        subtotalf = 0

        if blank_sheet
          1.times do |cd|
            cantidad = 0
            subtotal = 1 * cantidad
            r = [["", "", {:content => "$#{monto_to_currency(cantidad)}", :align => :right}, {:content => "#{monto_to_currency(subtotal)}", :align => :right}]]

            #r = [["1","",{:content=>"$#{'%.2f' % cantidad}",:align=>:right},{:content=>"$#{'%.2f' % subtotal}",:align=>:right}]]
            data += r
            counter = counter + 1
            subtotalf += subtotal
          end
        else
          cotizacion.cotizacion_detalle.each do |cd|
            subtotal = cd.precio_unitario * cd.cantidad
            if cd.cantidad.modulo(1).eql? 0
              cd_cantidad = cd.cantidad.to_i
            else
              cd_cantidad = cd.cantidad
            end
            r = [[cd_cantidad, cd.concepto, {:content => "#{monto_to_currency(cd.precio_unitario.to_s)}", :align => :right}, {:content => "#{monto_to_currency(subtotal.to_s)}", :align => :right}]]
            data += r
            counter = counter + 1
            subtotalf += subtotal
          end
        end

        ## DESCUENTO
        descuento = 0
        if cotizacion.descuento_porcentaje.nil?
          cotizacion.descuento_porcentaje = 0.00
        end
        if cotizacion.descuento_porcentaje > 0
          descuento = (subtotalf * cotizacion.descuento_porcentaje)/100
          subtotaldescuento = subtotalf - descuento
          iva = (subtotaldescuento * cotizacion.iva)/100
        else
          iva = (subtotalf * cotizacion.iva)/100
        end

        ## SUBTOTALES
        if descuento <= 0
          data +=[
              [{:content => "<font size='6'>#{t[:legal]}</font>", :colspan => 2, :rowspan => 3, :align => :justify, :inline_format => true},
               {:content => t[:subtotal], :align => :right},
               {:content => "#{monto_to_currency(subtotalf)}", :align => :right}],
              [{:content => "IVA", :align => :right}, {:content => "#{monto_to_currency(iva)}", :align => :right}],
              [{:content => "Total", :align => :right}, {:content => "#{monto_to_currency(subtotalf + iva)}", :align => :right}]]
        else
          data +=[
              [{:content => "<font size='6'>#{t[:legal]}</font>", :colspan => 2, :rowspan => 5, :align => :justify, :inline_format => true},
               {:content => t[:subtotal], :align => :right},
               {:content => "#{monto_to_currency(subtotalf)}", :align => :right}],
              [{:content => "Descuento #{cotizacion.descuento_porcentaje}", :align => :right}, {:content => "#{monto_to_currency(descuento)}", :align => :right}],
              [{:content => "Precio Venta", :align => :right}, {:content => "#{monto_to_currency(subtotaldescuento)}", :align => :right}],
              [{:content => "IVA", :align => :right}, {:content => "#{monto_to_currency(iva)}", :align => :right}],
              [{:content => "Total", :align => :right}, {:content => "#{monto_to_currency(subtotaldescuento + iva)}", :align => :right}]]
        end


        tabla = pdf.make_table(data, :header => false, :width => 505, :column_widths => [50, 305, 75, 75], :cell_style => {:valign => :center, :size => size - 2, :padding => 3, :border_width => 0.5})
        tabla.rows(1..counter).border_bottom_width= 0.1
        #tabla.row(counter + 1).column(0).borders = [:right]
        tabla.row(counter + 1).column(0).borders = []
        tabla.row(counter + 1).column(0).padding = 5
        #tabla.row(counter + 1).column(2).borders = []
        tabla.rows(counter+1..counter+5).column(2).borders = []
        tabla.draw
        pdf.text "\n\n"
        #OBSERVACIONES
        c_notas = nil
        cotizacion.notas.split("\n").each do |n|
          if !n.empty?
            c_notas = "#{c_notas} - #{n}\n"
          end
        end

        leyendas = ""
        cotizacion.solicitud.servicios.each do |srv|
          # leyendas << srv.costeos.select(:leyenda) { |costeo| !costeo.leyenda.blank? }.join("\n")
          leyendas << "- " + srv.costeos.select(:leyenda) { |costeo| !costeo.leyenda.blank? }[0].leyenda + "\n" rescue "-NADA-"
        end
        if !leyendas.strip.blank?
          pdf.text "Leyendas:
          #{leyendas}", :align => :justify, :size => 7
          pdf.text "\n"
        end

=begin
        hasLeyendas = cotizacion.solicitud.servicios.any? { |servicio|
          servicio.costeos.any? { |costeo| !costeo.leyenda.blank? }
        }
        if hasLeyendas
          pdf.text "Leyendas:
          - Las leyendas", :align => :justify, :size => 7
          pdf.text "\n"
        end
=end

        pdf.text "Notas:
- Esta cotización tiene una vigencia de 30 días hábiles.\n#{c_notas}- Se consideran días hábiles de lunes a viernes en un horario de 8:30 -13:30 y 14:00 - 16:30 h.\n- El cliente aprueba el procedimiento técnico y la realización de las pruebas o calibraciónes en su material o equipo al autorizar el servicio.\n- En caso de autorizar el servicio, el cliente deberá hacer llegar mediante este mismo medio la orden de trabajo que autorice los estudios a realizar y los materiales e información técnica de los mismos.\n- Si no se encuentra registrado en nuestro catálogo de cliente deberá pagar el costo del servicio para poder comenzar con el mismo,  a la cuenta Banorte 0127370266 clabe 072150001273702669 si el servicio corresponde a CIMAV Chihuahua y a la cuenta BANORTE 0252602458 clabe 072 150 00252602458 5 para servicios de CIMAV Monterrey. En caso de realizar deposito el cliente deberá hacer llegar por este mismo medio el comprobante de pago. \n- La orden de trabajo o comprobante de pago deberá contener el número de cotización autorizado. \n- Una vez finalizado el servicio, el cliente cuenta con 30 días para recoger sus muestras; transcurrido este tiempo se desechan.\n- En caso de que el informe de resultados requiera modificaciones, es responsabilidad del cliente el regreso del informe anterior para emitir el informe corregido.\n- La factura generará después de entregar el informe de resultados. En caso de que el cliente requiera la factura previamente, deberá solicitarla vía correo electrónico.\n- El cliente deberá informar la dirección de correo electrónico a donde se deba enviar la factura, así como el proceso de cobranza a seguir.\n- Para los servicios de calibración, si en un período preliminar de calibración el LABORATORIO DE METROLOGÍA observa que el instrumento está dañado se suspenderá el proceso de calibración, se le notificará  al cliente. Se entenderá que la  calibración solicitada ya no se efectuará. Queda establecido que el LABORATORIO DE METROLOGÍA no será responsable de los equipos que se hayan presentado dañados, con vicios ocultos o cualquier irregularidad. La fecha de entrega del instrumento aplica siempre y cuando el instrumento no requiera ajustes, ya que en este último caso (si se cuenta con todo lo necesario para llevar a cabo el ajuste), el tiempo puede extenderse. Si al instrumento le falta algún aditamento para realizar la calibración la fecha de recepción comenzará a contar a partir de que dicho elemento sea entregado al laboratorio. La recolección del instrumento en las instalaciones del laboratorio corre a cargo del cliente, excepto cuando se haya estipulado en la cotización su envío por mensajería.. El servicio de calibración no incluye ajuste o reparación de los instrumentos. Si se requiere la verificación de los resultados contra una tolerancia específica, ésta debe ser proporcionada por el solicitante. El informe de calibración se emitirá independientemente de que el instrumento no cumpla con la norma de referencia o especificaciones de tolerancias dadas. El  cliente puede definir cómo se expresarán los resultados (en que unidades, etc.), de no hacerlo, el LABORATORIO DE METROLOGÍA expresará los resultados según lo marque el procedimiento de calibración utilizado. (8). El cliente podrá especificar los puntos en los cuáles se calibrará el instrumento, de no hacerlo, el LABORATORIO DE METROLOGÍA escogerá los puntos según lo marque el procedimiento de calibración utilizado. Para su calibración los instrumentos deberán ser entregados en buenas condiciones de funcionamiento y limpios. En caso contrario no se realizará el servicio. El cliente proporcionará la información necesaria y dará todas las facilidades para el desarrollo del servicio. Para servicios de calibración, el LABORATORIO DE METROLOGÍA únicamente garantiza que el equipo del solicitante funciona en el lugar que se efectuó la calibración ya que durante el traslado a su lugar de origen cualquier movimiento brusco o falta de cuidado del transportador puede afectar la calibración.\n", :align => :justify, :size => 7
        pdf.text "\n"
        ## FOOTER
        y = -35
        ## Firmas
        w= (pdf.bounds.width / 2) + 10
        h= 15
        x= 0
        pdf.fill_color "e6e6e6"
        pdf.fill_rectangle [x, y + 45], w, h
        pdf.fill_color "000000"
        pdf.text_box "Elaboró CIMAV:", :at => [x, y + 45], :width => w, :height => h, :size => 9, :align => :left, :valign => :center

        h= 15
        x= x + (pdf.bounds.width / 2)
        pdf.fill_color "e6e6e6"
        pdf.fill_rectangle [x, y + 45], w, h
        pdf.fill_color "000000"
        pdf.text_box "Aceptó Cliente:", :at => [x, y + 45], :width => w, :height => h, :size => 9, :align => :left, :valign => :center

        ## USUARIO ELABORO
        x = 0
        y1 = y + 30
        w = 350
        h = 10

        if current_user
          full_name = "#{current_user.nombre} #{current_user.apellidos}"
        else
          full_name = "#{cotizacion.solicitud.usuario.nombre} #{cotizacion.solicitud.usuario.apellidos}"
        end
        if !blank_sheet
          pdf.text_box full_name, :at => [x, y1], :width => w, :height => h, :size => 9, :align => :left, :valign => :bottom
        end

        ## LINE 2
        x = 0
        y2 = y - 8
        pdf.stroke_color= "000000"
        pdf.line_width= 3
        pdf.stroke_line [x, y2], [505, y2]
        pdf.line_width= 1
        pdf.stroke_line [x, y2 - 3], [505, y2 - 3]

        ## Texto de Agradecimiento
        w= 300
        h= 17
        x= (pdf.bounds.width / 2)- (w/2)
        y3= y - 15
        pdf.fill_color "e6e6e6"
        pdf.fill_rectangle [x, y3], w, h
        pdf.fill_color "000000"
        pdf.text_box t[:gratitude], :at => [x, y3], :width => w, :height => h, :size => 9, :align => :center, :valign => :center, :style => :italic

        ## VERSION DOCUMENTO
        w = 90
        h = 12
        pdf.text_box t[:version], :at => [415, y+5], :width => w, :height => h, :size => 11, :align => :right, :valign => :bottom

        ## RESPONSABLE
        w = 200
        pdf.text_box t[:responsable], :at => [0, y+5], :width => w, :height => h, :size => 10, :align => :left, :valign => :bottom

        # pdf.repeat :all do
        # end

        #NUM. PAGINA
        x = pdf.bounds.left
        y4 = y - 40
        pdf.number_pages "<page>/<total>", {:at => [x, y4],
                                            :align => :center,
                                            :size => 11}
      end
    end

    def monto_to_currency(monto)
      ActionController::Base.helpers.number_to_currency(monto, :unit => '$')
    end

    def document
      pdf = create_document(params[:id])
      send_data pdf.render, type: "application/pdf", disposition: "inline"
    end

    def download_document
      if solicitud = Solicitud.where(vinculacion_hash: params[:vinculacion_hash]).first
        cotizacion_id = solicitud.ultima_cotizacion.id
        pdf = create_document(cotizacion_id)
        filename = solicitud.codigo.gsub('/', '_').concat('.pdf')
        send_data pdf.render, type: "application/pdf", disposition: "attachment", :filename => "cotizacion-#{filename}"
      else
        render :inline => 'INVALID HASH'
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

