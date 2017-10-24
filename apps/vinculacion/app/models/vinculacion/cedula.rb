# coding: utf-8
module Vinculacion
  class Cedula < ActiveRecord::Base
    belongs_to :solicitud
    belongs_to :servicio
    has_many :costo_variable
    has_many :remanentes

    after_update :check_status_for_netmultix

    attr_accessor :total_costo_variable
    attr_accessor :costo_indirecto
    attr_accessor :costo_interno
    attr_accessor :porcentaje_participacion
    attr_accessor :utilidad
    attr_accessor :precio_venta
    attr_accessor :remanente_distribuible

    INICIAL = 1
    TRANSMITIENDO = 2
    TRANSMITIDA = 3
    FALLA_TRANSMISION = 4
    ENVIANDO_COSTOS = 5
    COSTOS_ENVIADOS = 6
    FALLAN_COSTOS = 7
    CANCELADO = 99

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

    def init_cedula_netmultix

      # intenta empatar cliente sigre-netmultix
      cliente_rfc = self.solicitud.cliente.rfc rescue 'no-rfc'
      cliente_netmultix = ClienteNetmultix.where("cl01_rfc LIKE '%" + cliente_rfc + "%'").first rescue nil
      if !cliente_netmultix.nil?
        self.cliente_netmultix_id = cliente_netmultix.id
      end

      # inicializa la cédula con el proyecto default de la sede de la solicitud
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

      codigo_solicitud = self.solicitud.codigo.gsub("/","")

      # busca la solicitud/servicio en la descripción
      proy_netmultix = ProyectoNetmultix.where('trim(pr13_desc) LIKE trim(:q)', {:q => codigo_solicitud}).first rescue nil

      if !proy_netmultix.nil?
        # si el subproyecto existe en NetMultix
        sub_proyecto = proy_netmultix.pr13_subproyecto rescue '00000'
      else
        # si no existe, toma el subproyecto default por sede
        case self.solicitud.sede_id
          when 2 # MTY
            sub_proyecto = '2035000001'
          when 3 # DGO
            sub_proyecto = '2040900001'
          else # CHI
            # sub_proyecto = '2033000238'
            sub_proyecto = '2033000467' # oct 2017
        end
        #sub_proyecto = proyecto_id.to_s + sub_proyecto
        #proy_netmultix = ProyectoNetmultix.where('pr13_subproyecto LIKE :q', {:q => sub_proyecto}).first rescue nil
      end
      self.sub_proyecto = sub_proyecto

      # pone el detalle de la cotización como concepto en extenso
      self.concepto_en_extenso = self.solicitud.cotizaciones.last.cotizacion_detalle[servicio.consecutivo - 1].concepto rescue 'sin-concepto'

      self.observaciones = ' '

      # persistir
      self.save

    end

    def check_status_for_netmultix

      if self.status_changed?
        if self.status == TRANSMITIENDO
          self.transmitir_netmultix
        elsif self.status == ENVIANDO_COSTOS
          self.enviar_costos_netmultix
        end
      end

    end #check_status_for_netmultix

=begin

select * from ft61;
select * from ft16 where ft16_fecha >= 20160613 ORDER BY ft16_cedula desc;
select * from ft17 where ft17_cedula like '%863/16%';
select * from ft18 where ft18_cedula like '%863/16%';

delete from ft16 where ft16_cedula like '0863/16%';
delete from ft17 where ft17_cedula like '%863/16%';
delete from ft18 where ft18_cedula like '%863/16%';
UPDATE FT61 SET FT61_PROX = '863' WHERE FT61_TABLA = 16
commit;

=end


    def transmitir_netmultix

      # usuario_id que intenta realizar la transmisión
      self.usr_transmite_id = self.solicitud.usuario_id
      # momento del intento de transmisión
      self.transmitida_at = Time.now

      # buscar al Cliente de NetMultix
      cve_cliente_netmultix = self.cliente_netmultix_id.to_s.rjust(5, '0') rescue 'no-cve'
      begin
        cliente_netmultix = ClienteNetmultix.where("cl01_clave LIKE '%" + cve_cliente_netmultix + "%'").first
        if cliente_netmultix.nil?
          raise 'Cliente no encontrado!'
        end
      rescue => e
        # no encontró al cliente
        puts e
        self.status = FALLA_TRANSMISION
        self.save
        return
      end

      # poblar los valores de la Cédula
      begin
        cia = '1'
        fecha = Time.now ### La fecha tiene que llevar la hora
        anio = fecha.year.to_s.last(2) rescue '00' # el anio depende del anio real (fecha actual) y no de la solicitud o cedula del sigre
        fecha = fecha.year.to_s + fecha.month.to_s.rjust(2, '0') + fecha.day.to_s.rjust(2, '0')
        orden_compra = self.solicitud.orden_compra rescue 'sin-orden'
        sol_servicio = self.solicitud.codigo rescue 'sin/codigo'
        #sol_servicio = sol_servicio.split('/')
        #sol_servicio = sol_servicio.last + '/' + sol_servicio.first
#        servicio = 201
        servicio = 2001 # oct 2017
        tipo = 'S'
        proyecto = self.sub_proyecto
        descripcion = self.servicio.nombre rescue 'sin-descripcion|nombre-servicio' # 'desc corta de 40 nombre del servicio'
        descripcion = descripcion[0..42].gsub(/\s\w+$/, '...')
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
        requisitor = self.solicitud.contacto.nombre rescue 'sin-requisitor'
        cotizacion = self.solicitud.cotizaciones.first
        cotizacion_detalle = cotizacion.cotizacion_detalle.first
        cantidad = cotizacion_detalle.cantidad rescue 0
        precio_uni = cotizacion_detalle.precio_unitario rescue 0
        precio_vta =  cotizacion.precio_venta.nan? ? 0 : cotizacion.precio_venta rescue 0 ## cantida x precio_uni
        porce_costo_fijo = 17.26
        porce_max_remanente = 70
        porce_dist_inv = 35
        tot_costo_var = self.total_costo_variable.nan? ? 0 : self.total_costo_variable rescue 0
        tot_costo_fijo = porce_costo_fijo * tot_costo_var / 100 rescue 0
        monto_distribuir = self.utilidad_topada.nan? ? 0 : self.utilidad_topada rescue 0 # porce_max_remanente * precio_vta / 100 rescue 0
        monto_dist_inv = porce_dist_inv * monto_distribuir / 100 rescue 0
        saldo_fact = precio_vta
        status = 1
        proyecto_pago = self.sub_proyecto
        observaciones = self.observaciones.nil? ? '  ' : self.observaciones rescue 'sin-observaciones' ### observaciones larga hasta de 2000'
        aprobacion = 0
        fecha_prog = fecha
        moneda = cotizacion.divisa = 1 ? 'P' : 'D'

        #oct 2017
        cve_prov_serv = '          '
        tipo_factor_iva = 0.00
        tasa_iva = 16.00
        band_detalle = 0.00
        unidad = '          '
        unidad_sat = '   '
      rescue => e
        # falla al poblar variables
        puts e
        self.status = FALLA_TRANSMISION
        self.save
        return
      end

      CedulaNetmultix.transaction do

        begin
          # buscar consecutivo siguiente
          cedula_consecutivo_netmultix = CedulaConsecutivoNetmultix.where("ft61_tabla = 16").first
          consecutivo_cedula_int = cedula_consecutivo_netmultix.ft61_prox rescue -1
          if consecutivo_cedula_int <= 0
            raise StandardError, 'No hay consecutivo'
          end
          ##anio = self.codigo.split('/')[0] rescue '00'
          consecutivo_cedula_str = consecutivo_cedula_int.to_s.rjust(4, '0') + '/' + anio

          # insertar registro directamente en la DB; no usa el Save
          cedula_netmultix = CedulaNetmultix.create(
              ft16_cia: cia, ft16_cedula: consecutivo_cedula_str,  ft16_fecha: fecha, ft16_orden_compra: orden_compra,
              ft16_sol_servicio: sol_servicio, ft16_servicio: servicio,  ft16_tipo: tipo, ft16_proyecto: proyecto,
              ft16_desc: descripcion, ft16_conce_fac: concepto_factura, ft16_cve_cte: cliente_netmultix_cve,
              ft16_nombre: cliente_netmultix_nombre, ft16_rfc: cliente_netmultix_rfc, ft16_calle: cliente_netmultix_calle,
              ft16_colonia: cliente_netmultix_colonia, ft16_ciudad: cliente_netmultix_ciudad, ft16_postal: cliente_netmultix_postal,
              ft16_lada: cliente_netmultix_lada, ft16_telefono: cliente_netmultix_telefono, ft16_fax: cliente_netmultix_fax,
              ft16_requisitor: requisitor, ft16_cantidad: cantidad, ft16_precio_uni: precio_uni, ft16_precio_vta: precio_vta,
              ft16_porc_costo_fijo: porce_costo_fijo, ft16_porc_max_remanente: porce_max_remanente, ft16_porc_dist_inv: porce_dist_inv,
              ft16_total_costo_var: tot_costo_var, ft16_total_costo_fijo: tot_costo_fijo, ft16_monto_distribuir: monto_distribuir,
              ft16_monto_dist_inv: monto_dist_inv, ft16_saldo_fact: saldo_fact, ft16_status: status, ft16_proy_pago: proyecto_pago,
              ft16_observaciones: observaciones, ft16_aprobacion: 0, ft16_fecha_prog: fecha_prog, ft16_nombre2: '  ',
              ft16_localidad: 'localFalta', ft16_no_int: 'intFalta',  ft16_no_ext: 'extFalta', ft16_estado: cliente_netmultix_estado,
              ft16_pais: cliente_netmultix_pais, ft16_moneda: moneda, ft16_tipo_negocio: 0,
              ft16_cve_prod_serv: cve_prov_serv,
              ft16_tipo_factor_iva: tipo_factor_iva,
              ft16_tasa_iva: tasa_iva,
              ft16_band_detalle: band_detalle,
              ft16_unidad: unidad,
              ft16_unidad_sat: unidad_sat
          )

          self.cedula_netmultix = cedula_netmultix.ft16_cedula

          # Si las inserciones no fallaron, incrementa y actualiza el consecutivo en DB
          consecutivo_cedula_int = consecutivo_cedula_int + 1
          str_consecutivo = "ft61_prox = '" + consecutivo_cedula_int.to_s + "'"
          CedulaConsecutivoNetmultix.where("ft61_tabla = 16").update_all(str_consecutivo)
          # update_all no valida si tiene ID pero escribe directo a la DB salteandose la transaccion. Por eso lo dejamos al último

          # raise Exception, "solo para provocar el Rollback de prueba... "

          # No hubo fallas
          self.status = TRANSMITIDA

        rescue => e
          puts e
          self.status = FALLA_TRANSMISION
        ensure
          #
        end # begin

      end #CedulaNetmultix.transaction do

      # guardar la cédula (transmitida o con falla)
      self.save

    end

    def enviar_costos_netmultix

      # usuario_id que intenta realizar el envío
      self.usr_envia_id = self.solicitud.usuario_id
      # momento del intento del envío
      self.enviada_at = Time.now

      cia = '1'
      fecha = Time.now ### La fecha tiene que llevar la hora
      fecha = fecha.year.to_s + fecha.month.to_s.rjust(2, '0') + fecha.day.to_s.rjust(2, '0')

      CedulaNetmultix.transaction do

        begin

          # comprobar que exista la cédula-netmultix
          cedula_netmultix = CedulaNetmultix.where("ft16_cedula like '%" + self.cedula_netmultix  + "%'") rescue  nil
          if cedula_netmultix.nil?
            raise StandardError, 'No hay cedula_netmultix: ' + self.cedula_netmultix
          end

          # Detalle de cedula.
          # al ser Tipo 1 no requiere acumularlos
          # CostoVariableNetmultix.where(ft17_cedula: self.cedula_netmultix).destroy_all
          renglon = 1
          self.costo_variable.each do |variable|
            CostoVariableNetmultix.create(
                ft17_cia: cia,
                ft17_cedula: self.cedula_netmultix,
                ft17_renglon: renglon,
                ft17_descripcion: variable.descripcion,
                ft17_costo: variable.costo
            )
            renglon = renglon + 1
          end

          # Remanente distribuible
          # RemanenteNetmultix.where(ft18_cedula: self.cedula_netmultix).destroy_all
          self.remanentes.each do |remanente|
            empleado = Empleado.find(remanente.empleado_id)
            cve_emp = empleado.codigo rescue nil
            if !cve_emp.nil?
              RemanenteNetmultix.create(
                  ft18_cia: cia,
                  ft18_cedula: self.cedula_netmultix,
                  ft18_cve_emp: cve_emp,
                  ft18_porc_asig: remanente.porcentaje_participacion,
                  ft18_imp_dist: remanente.monto,
                  ft18_saldo_pagar: remanente.monto,
                  ft18_fecha_pago: fecha,
                  ft18_status: 4
              )
            end
          end

          # No hubo fallas
          self.status = COSTOS_ENVIADOS

        rescue => e
          puts e
          self.status = FALLAN_COSTOS
        ensure
          #
        end # begin

      end #CedulaNetmultix.transaction do

      # guardar la cédula (enviada o con falla)
      self.save

    end #enviar_costos_netmultix

  end
end
