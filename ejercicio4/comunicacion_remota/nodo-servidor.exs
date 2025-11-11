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

 defp procesar_mensaje(reseñas) do
    IO.puts("\n--- LIMPIEZA SECUENCIAL ---")
    Enum.each(reseñas, fn r ->
      {id, resumen} = Review.limpiar(r)
      IO.puts("Reseña #{id}: #{resumen}")
    end)
  end

  # Concurrente
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
