desc "Enviar email encuesta de seguimiento 45 días naturales después de la cotizar"
## crontab -e
# 00 10 * * * cd /Users/calderon/gdrive/smilodon/projects/rubymine/sigre; /bin/bash -l -c "RAILS_ENV=development rake seguimiento"
task :seguimiento => :environment do
  cotizaciones = ::Vinculacion::Cotizacion.where(fecha_notificacion: Date.today - 45.days)
  cotizaciones.each do |cotizacion|
    if cotizacion.status = 3 && cotizacion.solicitud.status <= 2
      ::Vinculacion::VinculacionMailer.seguimiento_solicitud(cotizacion.solicitud).deliver
    end
  end

end
