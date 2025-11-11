# backoffice_secuencial_struct.ex
defmodule BackofficeSecuencial do
  @moduledoc """
  Ejecución SECUENCIAL de tareas con structs.
  """

  def run(tareas \\ Tarea.tareas_default()) do
    IO.puts("\n=== Ejecución SECUENCIAL con Structs ===\n")

    mostrar_tareas(tareas)

    inicio = System.monotonic_time(:millisecond)
    tareas_completadas = Enum.map(tareas, &ejecutar_tarea/1)
    fin = System.monotonic_time(:millisecond)

    tiempo_total = fin - inicio
    mostrar_resumen(tareas_completadas, tiempo_total)

    {:ok, tareas_completadas, tiempo_total}
  end

  defp ejecutar_tarea(tarea) do
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

  defp mostrar_tareas(tareas) do
    IO.puts("📋 Tareas a ejecutar:")
    Enum.each(tareas, fn tarea ->
      IO.puts("   • #{tarea.nombre} [#{tarea.prioridad}] - #{tarea.descripcion}")
    end)
    IO.puts("")
  end

  defp mostrar_resumen(tareas, tiempo_total) do
    IO.puts("\n" <> String.duplicate("=", 50))
    IO.puts("📊 RESUMEN DE EJECUCIÓN")
    IO.puts(String.duplicate("=", 50))

    Enum.each(tareas, fn tarea ->
      estado_emoji = if tarea.estado == :completada, do: "✓", else: "✗"
      diferencia = tarea.tiempo_real - tarea.duracion_estimada
      diff_texto = if diferencia > 0, do: "+#{diferencia}", else: "#{diferencia}"

      IO.puts("#{estado_emoji} #{tarea.nombre}")
      IO.puts("   Estimado: #{tarea.duracion_estimada}ms | Real: #{tarea.tiempo_real}ms (#{diff_texto}ms)")
    end)

    tiempo_estimado_total = Enum.sum(Enum.map(tareas, & &1.duracion_estimada))
    tiempo_real_total = Enum.sum(Enum.map(tareas, & &1.tiempo_real))

    IO.puts("\n⏱  Tiempo total de ejecución: #{tiempo_total}ms")
    IO.puts("📈 Suma tiempos estimados: #{tiempo_estimado_total}ms")
    IO.puts("📊 Suma tiempos reales: #{tiempo_real_total}ms")
    IO.puts(String.duplicate("=", 50))
  end
end

BackofficeSecuencial.run()
