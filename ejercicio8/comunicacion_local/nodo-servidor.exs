defmodule Tarea do
  @moduledoc """
  Estructura para representar una tarea de backoffice.
  """
  defstruct [
    :nombre,
    :descripcion,
    :prioridad,
    :duracion_estimada,
    estado: :pendiente,
    resultado: nil,
    tiempo_real: nil
  ]

  @type t :: %__MODULE__{
    nombre: atom(),
    descripcion: String.t(),
    prioridad: :alta | :media | :baja,
    duracion_estimada: integer(),
    estado: :pendiente | :ejecutando | :completada | :fallida,
    resultado: any(),
    tiempo_real: integer() | nil
  }

  def new(nombre, descripcion, prioridad, duracion_estimada) do
    %__MODULE__{
      nombre: nombre,
      descripcion: descripcion,
      prioridad: prioridad,
      duracion_estimada: duracion_estimada
    }
  end

  def tareas_default do
    [
      new(:reindex, "Reindexar base de datos", :alta, 1500),
      new(:purge_cache, "Limpiar caché del sistema", :alta, 800),
      new(:build_sitemap, "Generar sitemap.xml", :media, 1200),
      new(:cleanup_logs, "Limpiar logs antiguos", :baja, 600),
      new(:backup_db, "Backup de base de datos", :alta, 2000)
    ]
  end
end

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

  # ✅ Procesar UNA tarea individual (struct %Tarea{})
  defp procesar_mensaje(%Tarea{} = tarea) do
    IO.puts("⏳ Iniciando: #{tarea.nombre} - #{tarea.descripcion}")
    IO.puts("   Prioridad: #{tarea.prioridad} | Estimado: #{tarea.duracion_estimada}ms")

    inicio = System.monotonic_time(:millisecond)

    # Simulación con variación del 80%-120% del tiempo estimado
    tiempo_real = round(tarea.duracion_estimada * Enum.random(80..120) / 100)
    Process.sleep(tiempo_real)

    fin = System.monotonic_time(:millisecond)
    tiempo_ejecucion = fin - inicio

    IO.puts("✓ OK tarea: #{tarea.nombre} (#{tiempo_ejecucion}ms)\n")

    tarea_completada = %{tarea |
      estado: :completada,
      resultado: :ok,
      tiempo_real: tiempo_ejecucion
    }

    {:ok, tarea.nombre, tiempo_ejecucion}
  end

  # ✅ Procesar LISTA de tareas (modo secuencial)
  defp procesar_mensaje(tareas) when is_list(tareas) do
    IO.puts("📋 Tareas a ejecutar (SECUENCIAL):")
    Enum.each(tareas, fn tarea ->
      IO.puts("   • #{tarea.nombre} [#{tarea.prioridad}] - #{tarea.descripcion}")
    end)
    IO.puts("")

    resultados = Enum.map(tareas, fn tarea ->
      procesar_tarea_individual(tarea)
    end)

    {:ok, resultados}
  end

  # Función auxiliar para procesar una tarea
  defp procesar_tarea_individual(%Tarea{} = tarea) do
    IO.puts("⏳ Iniciando: #{tarea.nombre} - #{tarea.descripcion}")
    IO.puts("   Prioridad: #{tarea.prioridad} | Estimado: #{tarea.duracion_estimada}ms")

    inicio = System.monotonic_time(:millisecond)
    tiempo_real = round(tarea.duracion_estimada * Enum.random(80..120) / 100)
    Process.sleep(tiempo_real)
    fin = System.monotonic_time(:millisecond)
    tiempo_ejecucion = fin - inicio

    IO.puts("✓ OK tarea: #{tarea.nombre} (#{tiempo_ejecucion}ms)\n")

    %{tarea |
      estado: :completada,
      resultado: :ok,
      tiempo_real: tiempo_ejecucion
    }
  end
end

NodoServidor.main()
