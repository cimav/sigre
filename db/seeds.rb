puts "Llenando paises..."
Pais.delete_all
open("db/seeds/paises.txt") do |paises|
    paises.read.each_line do |pais|
        codigo, nombre = pais.chomp.split("|")
        Pais.create!(:nombre => nombre, :codigo => codigo)
    end
end

puts "Llenando estados..."
Estado.delete_all
open("db/seeds/estados.txt") do |estados|
    estados.read.each_line do |estado|
        codigo, nombre = estado.chomp.split("|")
        Estado.create!(:nombre => nombre, :codigo => codigo)
    end
end

puts "Llenando cotizaciones..."
::Vinculacion::Cotizacion.delete_all
open("db/seeds/cotizaciones.txt") do |cotizaciones|
  cotizaciones.read.each_line do |cotizacion|
    solicitud_id, consecutivo, comentarios = cotizacion.chomp.split("|")
    ::Vinculacion::Cotizacion.create!(:solicitud_id => solicitud_id, :consecutivo => consecutivo, :comentarios => comentarios)
  end
end

puts "CotizacionesDetalle..."
::Vinculacion::CotizacionDetalle.delete_all
open("db/seeds/cotizaciones_detalle.txt") do |cotizaciones_detalle|
  cotizaciones_detalle.read.each_line do |cotizacion_detalle|
    cotizacion_id, cantidad, concepto, precio_unitario = cotizacion_detalle.chomp.split("|")
    ::Vinculacion::CotizacionDetalle.create!(:cotizacion_id => cotizacion_id, :cantidad => cantidad, :concepto => concepto, :precio_unitario => :precio_unitario)
  end
end

puts "Proyectos..."
::Vinculacion::Proyecto.delete_all
open("db/seeds/proyectos.txt") do |proyectos|
  proyectos.read.each_line do |proyecto|
    solicitud_id, codigo, descripcion = proyecto.chomp.split("|")
    ::Vinculacion::Proyecto.create!(:solicitud_id => solicitud_id, :codigo => codigo, :descripcion => descripcion)
  end
end

