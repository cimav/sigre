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

puts "Proyectos..."
::Vinculacion::Proyecto.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('vinculacion_proyectos')
open("db/seeds/proyectos.txt") do |proyectos|
  proyectos.read.each_line do |proyecto|
    id, codigo, nombre, descripcion = proyecto.chomp.split("|")
    ::Vinculacion::Proyecto.create!(:id => id, :codigo => codigo, :nombre=>nombre, :descripcion => descripcion)
  end
end


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

