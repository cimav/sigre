puts "Agregando Proyecto Contenedor de Servicios y otro de ejemplo"
Proyecto.delete_all
open("db/seeds/proyectos.txt") do |proyectos|
  proyectos.read.each_line do |proyecto|
    codigo, descripcion = pais.chomp.split("|")
    Proyecto.create!(:codigo => codigo, :descripcion => descripcion)
  end
end

