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
 defp procesar_mensaje(reseñas) do
    IO.puts("\n--- LIMPIEZA SECUENCIAL ---")
    Enum.each(reseñas, fn r ->
      {id, resumen} = Review.limpiar(r)
      IO.puts("Reseña #{id}: #{resumen}")
    end)
  end

 defp procesar_mensaje(reseñas) do
    IO.puts("\n--- LIMPIEZA CONCURRENTE ---")
    tareas = Enum.map(reseñas, fn r ->
      Task.async(fn -> Review.limpiar(r) end)
    end)

    Task.await_many(tareas)
    |> Enum.each(fn {id, resumen} ->
      IO.puts("Reseña #{id}: #{resumen}")
    end)
  end
end

NodoServidor.main()
