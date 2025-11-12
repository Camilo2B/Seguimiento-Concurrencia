defmodule Usuario do
  defstruct correo: "", edad: 0, nombre: ""

  def crear(correo, edad, nombre) do
    %Usuario{
      correo: correo,
      edad: edad,
      nombre: nombre
    }
  end
end


defmodule NodoCliente do

  @nodo_cliente :"cliente@192.168.137.239"
  @nodo_servidor :"servidor@192.168.137.239"
  @nombre_proceso :servicio_cadenas

 @mensajes  [
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
    IO.puts("SE INICIA EL CLIENTE")
    iniciar_nodo(@nodo_cliente)
    establecer_conexion(@nodo_servidor)
    |> iniciar_produccion()
  end

  defp iniciar_nodo(nombre) do
    Node.start(nombre)
    Node.set_cookie(:my_cookie)
  end

  defp establecer_conexion(nodo_remoto) do
    Node.connect(nodo_remoto)
  end

  defp iniciar_produccion(false), do: IO.puts("No se pudo conectar con el nodo servidor")

  defp iniciar_produccion(true) do
    enviar_mensajes()
    recibir_respuestas()
  end

  defp enviar_mensajes() do
    Enum.each(@mensajes, &enviar_mensaje/1)
  end

  defp enviar_mensaje(mensaje) do
    send({@nombre_proceso, @nodo_servidor}, {self(), mensaje})
  end

  defp recibir_respuestas() do
    receive do
      :fin -> :ok
      respuesta ->
        IO.puts("\t -> \"#{inspect(respuesta)}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
