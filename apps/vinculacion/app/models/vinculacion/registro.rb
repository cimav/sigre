module Vinculacion
  class Registro < ActiveRecord::Base
    belongs_to :empleado
    belongs_to :solicitud
    has_many :registro_notas

    STATUS_INFO = 0
    STATUS_ALERTA_ABIERTA = 1
    STATUS_ALERTA_CONTESTADA = 2
    STATUS_ALERTA_CERRADA = 99

    TIPO_INFO = 'INFO'
    TIPO_ALERTA = 'ALERTA'

    STATUS = {
        STATUS_INFO               => 'Informativo',
        STATUS_ALERTA_ABIERTA     => 'Alerta Abierta',
        STATUS_ALERTA_CONTESTADA  => 'Alerta Contestada',
        STATUS_ALERTA_CERRADA     => 'Alerta Cerrada'
    }

    def status_text
      STATUS[self.status]
    end

  end
end
