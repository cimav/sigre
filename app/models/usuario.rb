class Usuario < ActiveRecord::Base
  STATUS_ACTIVO = 1
  STATUS_SUSPENDIDO = 2

  # keeping the list of roles in Ruby
  ROLES = %w[admin interno externo]

  def admin?()
    self.role == "admin"
  end
  def interno?()
    self.role == "interno"
  end
  def externo?()
    self.role == "externo"
  end

end
