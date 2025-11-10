defmodule NodoCliente do

  @nombre_servicio_local :servicio_respuesta
  @servicio_local {@nombre_servicio_local, :nodocliente@cliente}
  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:servicio_cadenas, @nodo_remoto}

  # Lista de mensajes a procesar
 @mensajes = [
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

  def main() do
    IO.puts("PROCESO PRINCIPAL")

    @nombre_servicio_local
    |> registrar_servicio()

    establecer_conexion(@nodo_remoto)
    |> iniciar_produccion()
  end

  defp registrar_servicio(nombre_servicio_local),
    do: Process.register(self(), nombre_servicio_local)

  defp establecer_conexion(nodo_remoto) do
    Node.connect(nodo_remoto)
  end

  defp iniciar_produccion(false),
    do: IO.puts("No se pudo conectar con el nodo servidor")

  defp iniciar_produccion(true) do
    enviar_mensajes()
    recibir_respuestas()
  end

  defp enviar_mensajes() do
    Enum.each(@mensajes, &enviar_mensaje/1)
  end

  defp enviar_mensaje(mensaje) do
    send(@servicio_remoto, {@servicio_local, mensaje})
  end

  defp recibir_respuestas() do
    receive do
      :fin ->
        :ok

      respuesta ->
        IO.puts("\t -> \"#{respuesta}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
