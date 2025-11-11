defmodule NodoServidor do
  @nombre_servicio_local :servicio_cadenas

  def main() do
    IO.puts("PROCESO SECUNDARIO")
    registrar_servicio(@nombre_servicio_local)
    procesar_mensajes()
  end

  defp registrar_servicio(nombre_servicio_local),
    do: Process.register(self(), nombre_servicio_local)

  defp procesar_mensajes() do
    receive do
      {productor, mensaje} ->
        respuesta = procesar_mensaje(mensaje)
        send(productor, respuesta)

        if respuesta != :fin, do: procesar_mensajes()
    end
  end

  defp procesar_mensaje(:fin), do: :fin

  defp procesar_mensaje(ordenes) do
    IO.puts("\n--- PROCESO SECUENCIAL ---")
    Enum.each(ordenes, fn orden ->
      resultado = Orden.preparar(orden)
      IO.puts(resultado)
    end)
  end

  # Concurrente
  defp procesar_mensaje(ordenes) do
    IO.puts("\n--- PROCESO CONCURRENTE ---")
    tareas = Enum.map(ordenes, fn orden ->
      Task.async(fn -> Orden.preparar(orden) end)
    end)

    Task.await_many(tareas)
    |> Enum.each(&IO.puts/1)
  end
end

NodoServidor.main()
