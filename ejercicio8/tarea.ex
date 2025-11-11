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
