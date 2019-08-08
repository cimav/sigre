namespace :vinculacion_tasks do

  desc "Enviar email encuesta de seguimiento 45 días naturales después de la cotizar"

  # En automático se anexa a listado tasks del rake. Verificar en rake -T
  # para ejecutarla: RAILS_ENV=development rake encuesta_seguimiento

  # para automatizar su ejecución todo los días a las 10:00
  # crontab -e
  # 00 10 * * * cd /Users/calderon/gdrive/smilodon/projects/rubymine/sigre; /bin/bash -l -c "RAILS_ENV=development rake vinculacion_tasks:encuesta_seguimiento"
  # 00 10 * * * cd /home/rails/sigre/; /bin/bash -l -c "RAILS_ENV=production rake vinculacion_tasks:encuesta_seguimiento"

  task :encuesta_seguimiento => :environment do
    # cotizaciones de hace 45 días y que están en espera de respuesta del cliente
    cotizaciones = ::Vinculacion::Cotizacion.where(fecha_notificacion: Date.today - 45.days, status: 2)
    cotizaciones.each do |cotizacion|
      # 2: COTIZACION NOTIFICADA (la tiene el cliente)          2: SOLICITUD INICIAL O COTIZANDO
      if cotizacion.status = 2 && cotizacion.solicitud.status <= 2
        # lanza el Mailer
        ::Vinculacion::VinculacionMailer.encuesta_seguimiento(cotizacion.solicitud).deliver
      end
    end
  end


  desc "Probar encuesta de seguimiento"
  # probar con: RAILS_ENV=development rake  vinculacion_tasks:prueba_encuesta[14253]
  task :prueba_encuesta, [:id_coti] => :environment do |t, args|
    cotizaciones = ::Vinculacion::Cotizacion.where(id: args[:id_coti])
    cotizaciones.each do |cotizacion|
      ::Vinculacion::VinculacionMailer.encuesta_seguimiento(cotizacion.solicitud).deliver
    end
  end

end
