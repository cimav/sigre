
  class ServiciosAlertadosMailer
    @queue = :correo_sigre

    def self.perform(alerta_id, mensaje, afectados)
      ::Vinculacion::VinculacionMailer.servicios_alertados(alerta_id, mensaje, afectados).deliver
    end

  end
