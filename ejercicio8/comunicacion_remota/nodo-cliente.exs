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

defmodule NodoCliente do

  @nodo_cliente :"cliente@192.168.137.239"
  @nodo_servidor :"servidor@192.168.137.239"
  @nombre_proceso :servicio_cadenas

  @mensajes [
      %Tarea{:reindex, "Reindexar base de datos", :alta, 1500},
      %Tarea{:purge_cache, "Limpiar caché del sistema", :alta, 800},
      %Tarea{:build_sitemap, "Generar sitemap.xml", :media, 1200},
      %Tarea{:cleanup_logs, "Limpiar logs antiguos", :baja, 600},
      %Tarea{:backup_db, "Backup de base de datos", :alta, 2000}
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
