defmodule Main do
  def main do
    usuarios = [
      %Usuario{correo: "juanVelez@gmail.com", edad: 40, nombre: "Juan Velez"},
      %Usuario{correo: "mariaDelMarBaena@gmail.com", edad: 21, nombre: "Maria Del Mar"},
      %Usuario{correo: "correo-malo.com", edad: 11, nombre: "Jefferson"},
      %Usuario{correo: "anaTorres@gmail.com", edad: -14, nombre: "Ana"},
     %Usuario{correo: "JeisonJaramillo@gmail.com", edad: 42, nombre: ""},
      %Usuario{correo: "JMendez@", edad: 33, nombre: "Jaime Mendez"},
     %Usuario{correo: "LauraSofiaM@gmail.com", edad: 20, nombre: "Laura Sofia"},
     %Usuario{correo: "JonathanJosean@yahoo.com", edad: 60, nombre: "JoJo"},
      %Usuario{correo: "   @example.com", edad: 22, nombre: "Johannes"},
     %Usuario{correo: "LinaMaria@gmail.com", edad: 53, nombre: " "},
      %Usuario{correo: "nestor@example.com", edad: 13, nombre: "nestor"},
    %Usuario{correo: "mauricio@example.com", edad: 101, nombre: "mauricio"},
     %Usuario{correo: "MarcelaArroyave.com", edad: 25, nombre: "Marcela"},
     %Usuario{correo: "JhanSneider@mail.com", edad: 21, nombre: "JhanSneider"},
     %Usuario{correo: "ArthurMorgan@gmail.com", edad: 44, nombre: "Arthur"},
    ]


    t1 = Benchmark.tiempo({Procesador, :procesar_secuencial, [usuarios]})

    t2 = Benchmark.tiempo({Procesador, :procesar_concurrente, [usuarios]})

    IO.puts(Benchmark.mensaje(t1, t2))
  end
end

Main.main()
