  class AlertaResueltaMailer
    @queue = :correo_sigre

    def self.perform(alerta_id)
      ::Vinculacion::VinculacionMailer.alerta_resuelta(alerta_id).deliver
    end

  end