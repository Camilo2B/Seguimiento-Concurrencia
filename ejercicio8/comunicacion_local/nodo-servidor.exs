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

  defp procesar_mensaje(tarea) do
    IO.puts("⏳ Iniciando: #{tarea.nombre} - #{tarea.descripcion}")
    IO.puts("   Prioridad: #{tarea.prioridad} | Estimado: #{tarea.duracion_estimada}ms")

    inicio = System.monotonic_time(:millisecond)
    tarea_actualizada = %{tarea | estado: :ejecutando}

    # Simulación con variación del 80%-120% del tiempo estimado
    tiempo_real = round(tarea.duracion_estimada * Enum.random(80..120) / 100)
    Process.sleep(tiempo_real)

    fin = System.monotonic_time(:millisecond)
    tiempo_ejecucion = fin - inicio

    IO.puts("✓ OK tarea: #{tarea.nombre} (#{tiempo_ejecucion}ms)\n")

    %{tarea_actualizada |
      estado: :completada,
      resultado: :ok,
      tiempo_real: tiempo_ejecucion
    }
  end

  defp procesar_mensaje(tareas) do
    IO.puts("📋 Tareas a ejecutar:")
    Enum.each(tareas, fn tarea ->
      IO.puts("   • #{tarea.nombre} [#{tarea.prioridad}] - #{tarea.descripcion}")
    end)
    IO.puts("")
  end

  def procesar_mensaje(tareas \\ Tarea.tareas_default()) do
    IO.puts("\n=== Ejecución CONCURRENTE con Structs ===\n")

    mostrar_tareas(tareas)

    inicio = System.monotonic_time(:millisecond)
    parent = self()

    Enum.each(tareas, fn tarea ->
      spawn(fn -> ejecutar_tarea(tarea, parent) end)
    end)

    tareas_completadas = recibir_resultados(length(tareas), [])

    fin = System.monotonic_time(:millisecond)
    tiempo_total = fin - inicio

    mostrar_resumen(tareas_completadas, tiempo_total)

    {:ok, tareas_completadas, tiempo_total}
  end

end

NodoServidor.main()
