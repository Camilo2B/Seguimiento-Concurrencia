# tarea.ex
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

  @nodo_servidor :"servidor@192.168.137.239"
  @nombre_proceso :servicio_cadenas

  def main() do
    IO.puts("SE INICIA EL SERVIDOR")
    iniciar_nodo(@nodo_servidor)
    registrar_servicio(@nombre_proceso)
    procesar_mensajes()
  end

  def iniciar_nodo(nombre) do
    Node.start(nombre)
    Node.set_cookie(:my_cookie)
  end

  defp registrar_servicio(nombre_servicio_local), do:
    Process.register(self(), nombre_servicio_local)

  defp procesar_mensajes() do
    receive do
      {productor, :fin} ->
        send(productor, :fin)
      {productor, mensaje} ->
        respuesta = procesar_mensaje(mensaje)
        send(productor, respuesta)
        procesar_mensajes()
    end
  end

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
