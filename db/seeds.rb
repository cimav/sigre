# puts "Llenando paises..."
# Pais.delete_all
# open("db/seeds/paises.txt") do |paises|
#     paises.read.each_line do |pais|
#         codigo, nombre = pais.chomp.split("|")
#         Pais.create!(:nombre => nombre, :codigo => codigo)
#     end
# end

# puts "Llenando estados..."
# Estado.delete_all
# open("db/seeds/estados.txt") do |estados|
#     estados.read.each_line do |estado|
#         codigo, nombre = estado.chomp.split("|")
#         Estado.create!(:nombre => nombre, :codigo => codigo)
#     end
# end

# puts "VINCULACION - Proyectos..."
# ::Vinculacion::Proyecto.delete_all
# ActiveRecord::Base.connection.reset_pk_sequence!('vinculacion_proyectos')
# open("db/seeds/vinculacion_proyectos.txt") do |proyectos|
#   proyectos.read.each_line do |proyecto|
#     id, cuenta, nombre, descripcion = proyecto.chomp.split("|")
#     ::Vinculacion::Proyecto.create!(:id => id, :cuenta => cuenta, :nombre=>nombre, :descripcion => descripcion)
#   end
# end


#puts "Llenando solicitudes..."
#open("db/seeds/solicitudes.txt") do |solicitudes|
#  solicitudes.read.each_line do |solicitud|
#    id, consecutivo, codigo, proyecto_id, notas = solicitud.chomp.split("|")
#    ::Vinculacion::Solicitud.create!(:id => id, :consecutivo => consecutivo, :codigo => codigo, :proyecto_id => proyecto_id, :notas => notas)
#  end
#end

# puts "Llenando cotizacion..."
# ::Vinculacion::Cotizacion.delete_all
# open("db/seeds/cotizaciones.txt") do |cotizaciones|
#   cotizaciones.read.each_line do |cotizacion|
#     id, solicitud_id, consecutivo, comentarios = cotizacion.chomp.split("|")
#     ::Vinculacion::Cotizacion.create!(:id => id, :solicitud_id => solicitud_id, :consecutivo => consecutivo, :comentarios => comentarios)
#   end
# end

#puts "CotizacionesDetalle..."
#::Vinculacion::CotizacionDetalle.delete_all
#open("db/seeds/cotizaciones_detalle.txt") do |cotizaciones_detalle|
#  cotizaciones_detalle.read.each_line do |cotizacion_detalle|
#    id, cotizacion_id, cantidad, concepto, precio_unitario = cotizacion_detalle.chomp.split("|")
#    #::Vinculacion::CotizacionDetalle.create!({:id => id, :cotizacion_id => cotizacion_id, :cantidad => cantidad, :concepto => concepto, :precio_unitario => :precio_unitario}, :without_protection => true)
#    ::Vinculacion::CotizacionDetalle.create!(:id => id, :cotizacion_id => cotizacion_id, :cantidad => cantidad, :concepto => concepto, :precio_unitario => :precio_unitario)
#  end
#end

puts "Sedes..."
::Rh::Sede.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('rh_sedes')
open("db/seeds/sedes.txt") do |sedes|
  sedes.read.each_line do |sede|
    id, nombre, descripcion = sede.chomp.split("|")
    ::Rh::Sede.create!(:id => id, :nombre=>nombre, :descripcion=>descripcion)
  end
end

puts "Departamentos..."
::Rh::Departamento.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('rh_departamentos')
open("db/seeds/departamentos.txt") do |deptos|
  deptos.read.each_line do |depto|
    id, nombre, descripcion, sede_id = depto.chomp.split("|")
    ::Rh::Departamento.create!(:id => id, :nombre=>nombre, :descripcion=>descripcion, :sede_id=>sede_id)
  end
end

puts "Empleados..."
::Rh::Empleado.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('rh_empleados')
open("db/seeds/empleados.txt") do |empleados|
  empleados.read.each_line do |empleado|
    id, nombre, apellido_paterno, apellido_materno, email, codigo, puesto, sede_id, departamento_id = empleado.chomp.split("|")
    ::Rh::Empleado.create!(:id=>id, :nombre=>nombre, :apellido_paterno=>apellido_paterno, :apellido_materno=>apellido_materno, :email=>email, :codigo=>codigo, :puesto=>puesto, :sede_id=>sede_id, :departamento_id=>departamento_id )
  end
end


puts "Monedas..."
Moneda.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('monedas')
open("db/seeds/monedas.txt") do |monedas|
  monedas.read.each_line do |moneda|
    id, codigo, nombre= moneda.chomp.split("|")
    Moneda.create!(:id => id, :codigo=>codigo, :nombre=>nombre)
  end
end

puts "Fondos..."
::Proyectos::Fondo.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('proyectos_fondos')
open("db/seeds/fondos.txt") do |sedes|
  sedes.read.each_line do |sede|
    id, nombre, recurso_id = sede.chomp.split("|")
    ::Proyectos::Fondo.create!(:id => id, :nombre=>nombre, :recurso_id=>recurso_id)
  end
end

puts "Tipos de proyectos..."
::Proyectos::Tipo.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('proyectos_tipos')
open("db/seeds/tipos_proyecto.txt") do |tipos|
  tipos.read.each_line do |tipo|
    id, nombre = tipo.chomp.split("|")
    ::Proyectos::Tipo.create!(:id => id, :nombre=>nombre)
  end
end

puts "Recursos..."
::Proyectos::Recurso.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('proyectos_recrusos')
open("db/seeds/recursos.txt") do |recursos|
  recursos.read.each_line do |recurso|
    id, nombre, descripcion, tipo_id = recurso.chomp.split("|")
    ::Proyectos::Recurso.create!(:id => id, :nombre=>nombre, :descripcion=>descripcion, :tipo_id=>tipo_id)
  end
end

puts "PROYECTOS - Proyectos..."
::Proyectos::Proyecto.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('proyectos_proyectos')
open("db/seeds/proyectos.txt") do |proyectos|
  proyectos.read.each_line do |proyecto|

    id, cuenta, nombre, descripcion, impacto, resultado_esperado, objetivo_estrategico, alcance, referencia_externa, convenio, banco_cuenta, fecha_inicio, fecha_fin, anio, presupuesto_autorizado, fondo_id, recurso_id,
    tipo_id, departamento_id, sede_id, moneda_id, responsable_id = proyecto.chomp.split("|")
    ::Proyectos::Proyecto.create!( :id=>id , :cuenta=>cuenta , :nombre=>nombre, :descripcion=>descripcion , :impacto=>impacto , :resultado_esperado=>resultado_esperado , :objetivo_estrategico=>objetivo_estrategico ,
                                   :alcance=>alcance , :referencia_externa=>referencia_externa , :convenio=>convenio , :banco_cuenta=>banco_cuenta , :fecha_inicio=>fecha_inicio , :fecha_fin=>fecha_fin , :anio=>anio ,
                                   :presupuesto_autorizado=>presupuesto_autorizado , :fondo_id=>fondo_id , :recurso_id=>recurso_id , :tipo_id=>tipo_id , :departamento_id=>departamento_id , :sede_id=>sede_id ,
                                   :moneda_id=>moneda_id , :responsable_id=>responsable_id)
  end
end
