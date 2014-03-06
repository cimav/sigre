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
