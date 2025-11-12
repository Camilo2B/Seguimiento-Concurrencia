defmodule Orden do
  defstruct id: 0, item: "", prep_ms: 0

  def crear_orden(id, item, prep_ms) do
    %Orden{id: id, item: item, prep_ms: prep_ms}
  end

  def preparar(%Orden{} = orden) do
    :timer.sleep(orden.prep_ms)
    "Ticket listo para #{orden.item}"
  end
end


defmodule NodoCliente do

  @nombre_servicio_local :servicio_respuesta
  @servicio_local {@nombre_servicio_local, :nodocliente@cliente}
  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:servicio_cadenas, @nodo_remoto}

  @mensajes [
      Orden.crear_orden(1, "Capuchino", 300),
      Orden.crear_orden(2, "Latte", 400),
      Orden.crear_orden(3, "Tostadas", 250),
      Orden.crear_orden(4, "Jugo de naranja", 350),
      Orden.crear_orden(5, "Croissant", 500)
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
        IO.puts("\t -> \"#{inspect(respuesta)}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
