defmodule NodoCliente do

  @nombre_servicio_local :servicio_respuesta
  @servicio_local {@nombre_servicio_local, :nodocliente@cliente}
  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:servicio_cadenas, @nodo_remoto}

  @mensajes [
      %Tarea{:reindex, "Reindexar base de datos", :alta, 1500},
      %Tarea{:purge_cache, "Limpiar caché del sistema", :alta, 800},
      %Tarea{:build_sitemap, "Generar sitemap.xml", :media, 1200},
      %Tarea{:cleanup_logs, "Limpiar logs antiguos", :baja, 600},
      %Tarea{:backup_db, "Backup de base de datos", :alta, 2000}
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
        IO.puts("\t -> \"#{respuesta}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
