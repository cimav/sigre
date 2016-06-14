# coding: utf-8
module Vinculacion
  class Cedula < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :servicio
    has_many :costo_variable
    has_many :remanentes

    after_update :check_status_for_transmitir
    before_create :init_proyecto

    attr_accessor :total_costo_variable
    attr_accessor :costo_indirecto
    attr_accessor :costo_interno
    attr_accessor :porcentaje_participacion
    attr_accessor :utilidad
    attr_accessor :precio_venta
    attr_accessor :remanente_distribuible

    INICIAL       = 1
    TRANSMITIENDO = 2
    TRANSMITIDA   = 3
    FALLA         = 4
    CANCELADO     = 99

    def total_costo_variable
      self.costo_variable.sum('costo')
    end

    def costo_indirecto
      self.total_costo_variable * 0.1726
    end

    def costo_interno
      self.total_costo_variable + self.costo_indirecto
    end

    def porcentaje_participacion
      self.costo_interno * 100 / self.solicitud.costo_interno
    end

    def precio_venta
      self.porcentaje_participacion * self.solicitud.precio_venta / 100
    end

    def utilidad_neta
      self.precio_venta - self.costo_interno
    end

    def utilidad_topada
      tope = 70 * self.precio_venta / 100
      self.utilidad_neta > tope ? tope : self.utilidad_neta
    end

    def remanente_distribuible
      self.utilidad_topada * 0.35
    end

    def init_proyecto

      # inicializa la cédula con le proyecto default de la sede de la solicitud
      sede_id = self.solicitud.sede_id
      case sede_id
        when 2 # MTY
          proy_id = 20350
        when 3 # DGO
          proy_id = 20409
        else # CHI
          proy_id = 20330
      end
      self.proyecto_id = proy_id

    end

    def check_status_for_transmitir
      if self.status_changed? && self.status == TRANSMITIENDO

        # buscar al Cliente de NetMultix
          cve_cliente_netmultix = self.cliente_netmultix_id.to_s.rjust(5,'0') rescue 'no-cve'
          begin
            cliente_netmultix = ClienteNetmultix.where("cl01_clave LIKE '%" + cve_cliente_netmultix + "%'").first
            if cliente_netmultix.nil?
              raise 'Cliente no encontrado!'
            end
          rescue => e
            puts e
            self.status = FALLA
            self.save
            return
          end

          # poblar los valores
          cia = '1'
          fecha = Time.now
          fecha = fecha.year.to_s + fecha.month.to_s.rjust(2,'0') + fecha.day.to_s.rjust(2,'0')
          orden_compra = self.solicitud.orden_compra rescue 'sin-orden'
          sol_servicio = self.solicitud.codigo rescue 'sin/codigo'
          #sol_servicio = sol_servicio.split('/')
          #sol_servicio = sol_servicio.last + '/' + sol_servicio.first
          #######
          servicio = 201
          tipo = 'S'
          ######
          proyecto = self.sub_proyecto
          descripcion = self.servicio.nombre rescue 'sin-descripcion|nombre-servicio' # 'desc corta de 40 nombre del servicio'
          descripcion = descripcion[0..42].gsub(/\s\w+$/,'...')
          concepto_factura = self.concepto_en_extenso rescue 'sin-concepto-extenso' ######### descripcion muy larga 2000 (maybe de la solicitud)
          cliente_netmultix_cve = cliente_netmultix.cl01_clave rescue 'sin-clave-cliente-net'
          cliente_netmultix_nombre = cliente_netmultix.cl01_nombre rescue 'sin-nombre-cliente-net'
          cliente_netmultix_rfc = cliente_netmultix.cl01_rfc rescue 'sin-rfc-cliente-net'
          cliente_netmultix_calle = cliente_netmultix.cl01_calle rescue 'sin-calle-cliente-net'
          cliente_netmultix_colonia = cliente_netmultix.cl01_colonia rescue 'sin-colonia-cliente-net'
          cliente_netmultix_ciudad = cliente_netmultix.cl01_ciudad rescue 0
          cliente_netmultix_postal = cliente_netmultix.cl01_postal rescue 'sin-postal-cliente-net'
          cliente_netmultix_lada = cliente_netmultix.cl01_lada rescue 'sin-lada-cliente-net'
          cliente_netmultix_telefono = cliente_netmultix.cl01_telefono1 rescue 'sin-tel1-cliente-net'
          cliente_netmultix_fax = cliente_netmultix.cl01_fax rescue 'sin-fax-cliente-net'
          cliente_netmultix_pais = cliente_netmultix.cl01_pais rescue 0
          cliente_netmultix_estado = cliente_netmultix.cl01_estado rescue 0
          cliente_netmultix_localidad = cliente_netmultix.cl01_localidad rescue 'sin-localidad'
          cliente_netmultix_tipo = cliente_netmultix.cl01_tipo_negocio rescue 0
          requisitor = self.servicio.empleado.nombre_completo rescue 'sin-requisitor' ############ debe ser el contacto
          cotizacion = self.solicitud.cotizaciones.first
          cotizacion_detalle = cotizacion.cotizacion_detalle.first
          cantidad = cotizacion_detalle.cantidad rescue 0
          precio_uni = cotizacion_detalle.precio_unitario rescue 0
          precio_vta = self.precio_venta.nan? ? 0 : self.precio_venta rescue 0 ## cantida x precio_uni
          porce_costo_fijo = 17.26
          porce_max_remanente = 70
          porce_dist_inv = 35
          tot_costo_var = self.total_costo_variable.nan? ? 0 : self.total_costo_variable rescue 0
          tot_costo_fijo = porce_costo_fijo * tot_costo_var / 100 rescue 0
          monto_distribuir = self.utilidad_topada.nan? ? 0 : self.utilidad_topada rescue 0  # porce_max_remanente * precio_vta / 100 rescue 0
          monto_dist_inv = porce_dist_inv * monto_distribuir / 100 rescue 0
          saldo_fact = precio_vta
          status = 1
          #######
          proyecto_pago =  self.sub_proyecto
          observaciones = self.concepto_en_extenso rescue 'sin-observaciones' ### observaciones larga hasta de 20000
          aprobacion = 0
          fecha_prog = fecha
          moneda = cotizacion.divisa = 1 ? 'P' : 'D'

=begin
          begin
            # consecutivo siguiente
            conn_netmultix = ActiveRecord::Base.establish_connection(:development_netmultix)
            consecutivo_cedula = conn_netmultix.connection.execute('SELECT FT61_PROX FROM FT61 WHERE FT61_TABLA = 16  AND ROWNUM <= 1').fetch
            consecutivo_cedula = consecutivo_cedula[0] + 10
            ##### Falta el anio
            consecutivo_cedula = consecutivo_cedula.to_s.rjust(4,'0') + '/17'
          rescue => e
            puts e
            self.status = FALLA
            self.save
            return
          ensure
            conn_netmultix.disconnect! unless conn_netmultix.nil?
          end
=end

       CedulaNetmultix.transaction do

          begin

            # buscar consecutivo siguiente
            cedula_consecutivo_netmultix = CedulaConsecutivoNetmultix.where("ft61_tabla = 16").first
            consecutivo_cedula_int = cedula_consecutivo_netmultix.ft61_prox + 10
            ##### Falta el anio
            consecutivo_cedula_str = consecutivo_cedula_int.to_s.rjust(4,'0') + '/17'

            # insertar registro directamente en la DB; no usa el Save
            cedula_netmultix = CedulaNetmultix.create(
                ft16_cia: cia,
                ft16_cedula: consecutivo_cedula_str,
                ft16_fecha: fecha,
                ft16_orden_compra: orden_compra,
                ft16_sol_servicio: sol_servicio,
                ft16_servicio: servicio,
                ft16_tipo: tipo,
                ft16_proyecto: proyecto,
                ft16_desc: descripcion,
                ft16_conce_fac: concepto_factura,
                ft16_cve_cte: cliente_netmultix_cve,
                ft16_nombre: cliente_netmultix_nombre,
                ft16_rfc: cliente_netmultix_rfc,
                ft16_calle: cliente_netmultix_calle,
                ft16_colonia: cliente_netmultix_colonia,
                ft16_ciudad: cliente_netmultix_ciudad,
                ft16_postal: cliente_netmultix_postal,
                ft16_lada: cliente_netmultix_lada,
                ft16_telefono: cliente_netmultix_telefono,
                ft16_fax: cliente_netmultix_fax,
                ft16_requisitor: requisitor,
                ft16_cantidad: cantidad,
                ft16_precio_uni: precio_uni,
                ft16_precio_vta: precio_vta,
                ft16_porc_costo_fijo: porce_costo_fijo,
                ft16_porc_max_remanente: porce_max_remanente,
                ft16_porc_dist_inv: porce_dist_inv,
                ft16_total_costo_var: tot_costo_var,
                ft16_total_costo_fijo: tot_costo_fijo,
                ft16_monto_distribuir: monto_distribuir,
                ft16_monto_dist_inv: monto_dist_inv,
                ft16_saldo_fact: saldo_fact,
                ft16_status: status,
                ft16_proy_pago: proyecto_pago,
                ft16_observaciones: observaciones,
                ft16_aprobacion: 0,
                ft16_fecha_prog: fecha_prog,
                ft16_nombre2: '  ', # por si el nombre es demasiado extenso
                ft16_localidad: 'localFalta',
                ft16_no_int: 'intFalta',
                ft16_no_ext: 'extFalta',
                ft16_estado: cliente_netmultix_estado,
                ft16_pais: cliente_netmultix_pais,
                ft16_moneda: moneda,
                ft16_tipo_negocio: 	0
            )

            puts cedula_netmultix.ft16_cedula
            self.cedula_netmultix = cedula_netmultix.ft16_cedula

            ## Si la insercion no tuvo fallas, actualizar el consecutivo en DB
            #cedula_consecutivo_netmultix.update_column("ft61_prox",  "'" + consecutivo_cedula_int.to_s + "'" )

            cad = "ft61_prox = '" +  consecutivo_cedula_int.to_s + "'"
            CedulaConsecutivoNetmultix.where("ft61_tabla = 16").update_all(cad)



#            conn_netmultix = ActiveRecord::Base.establish_connection(:development_netmultix)
           ## conn_netmultix.connection.execute("UPDATE FT61 SET FT61_PROX = '" + consecutivo_cedula_int.to_s + "' WHERE FT61_TABLA = 16").fetch
           ## conn_netmultix.disconnect! unless conn_netmultix.nil?

#            conn_netmultix.connection.raw_connection.exec("UPDATE FT61 SET FT61_PROX = '" + consecutivo_cedula_int.to_s + "' WHERE FT61_TABLA = 16")
#            conn_netmultix.connection.close

            #conn_netmultix.raw_connection.prepare("UPDATE FT61 SET FT61_PROX = ? WHERE FT61_TABLA = 16")
            #conn_netmultix.execute(consecutivo_cedula_int.to_s)
            #conn_netmultix.close

            # conn_netmultix.connection.raw_connection.exec("UPDATE FT61 SET FT61_PROX = '868' WHERE FT61_TABLA = 16")

            #st = ActiveRecord::Base.connection.raw_connection.prepare("update table set f1=? where f2=? and f3=?")
            #st.execute(f1, f2, f3)
            #st.close

=begin
               Detalle de cedula lleva el costo de cada participante
               La Distribucion lleva el % y lo que se llevan del remanente
=end

          rescue => e
            puts e
            self.status = FALLA
            self.save ## al ser de otra DB, el save no va dentro de la transaction ??
            return
          ensure
            #
          end

          self.status = TRANSMITIDA
          self.save

        end #CedulaNetmultix.transaction do

       end # if self.status_changed? && self.status == TRANSMITIENDO
    end #check_status_for_transmitir


  end
end
