defmodule NodoCliente do
  @nombre_servicio_local :servicio_respuesta
  @servicio_local {@nombre_servicio_local, :nodocliente@cliente}
  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:servicio_cadenas, @nodo_remoto}

  # ✅ IMPORTANTE: Usa Tarea.tareas_default() que devuelve structs
  @mensajes Tarea.tareas_default()

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

  # Opción 1: Enviar una tarea a la vez
  defp enviar_mensajes() do
    Enum.each(@mensajes, &enviar_mensaje/1)
  end

  # Opción 2: Enviar todas las tareas juntas (descomenta si prefieres esto)
  # defp enviar_mensajes() do
  #   send(@servicio_remoto, {@servicio_local, @mensajes})
  # end

  defp enviar_mensaje(mensaje) do
    send(@servicio_remoto, {@servicio_local, mensaje})
  end

  defp recibir_respuestas() do
    receive do
      :fin ->
        :ok

      respuesta ->
        IO.puts("\t -> #{inspect(respuesta)}")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
