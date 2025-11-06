defmodule Main do
  def main do
    usuarios = [
      %User{email: "juan@example.com", edad: 25, nombre: "Juan Perez"},
      %User{email: "maria123@example.com", edad: 19, nombre: "Maria"},
      %User{email: "invalid-email.com", edad: 30, nombre: "Carlos"},     # correo inválido
      %User{email: "ana@example.com", edad: -5, nombre: "Ana"},         # edad negativa
     %User{email: "pedro@example.com", edad: 45, nombre: ""},          # nombre vacío
      %User{email: "lola@", edad: 22, nombre: "Lola Ruiz"},             # correo sin dominio
     %User{email: "sofia@example.org", edad: 0, nombre: "  Sofia  "},  # válido
     %User{email: "roberto@example.net", edad: 80, nombre: "Roberto"}, # válido
      %User{email: "   @example.com", edad: 18, nombre: "Luis"},        # correo sin usuario
     %User{email: "vale@example.com", edad: 20, nombre: " "},          # nombre vacío (espacios)
      %User{email: "david@example.com", edad: 13, nombre: "David"},     # válido
    %User{email: "jose@example.com", edad: 150, nombre: "Jose"},      # válido (edad válida)
     %User{email: "sin_arrobaexample.com", edad: 25, nombre: "Noelia"},# falta @
     %User{email: "nina@mail.com", edad: 29, nombre: "Nina"},          # válido
     %User{email: "x@x.x", edad: 40, nombre: "Min"},                   # válido
    ]


    t1 = Benchmark.tiempo({Procesador, :procesar_secuencial, [usuarios]})

    t2 = Benchmark.tiempo({Procesador, :procesar_concurrente, [usuarios]})

    IO.puts(Benchmark.mensaje(t1, t2))
  end
end

Main.main()
