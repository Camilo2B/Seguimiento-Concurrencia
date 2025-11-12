defmodule Review do
  defstruct id: 0, texto: ""

  def crear(id, texto) do
    %Review{id: id, texto: texto}
  end

  def limpiar(%Review{} = review) do
    texto_limpio =
      review.texto
      |> String.downcase()
      |> String.replace(~r/[áàâä]/, "a")
      |> String.replace(~r/[éèêë]/, "e")
      |> String.replace(~r/[íìîï]/, "i")
      |> String.replace(~r/[óòôö]/, "o")
      |> String.replace(~r/[úùûü]/, "u")
      |> String.replace(~r/\b(el|la|los|las|un|una|unos|unas|de|y|a|en|por)\b/, "")
      |> String.trim()

    :timer.sleep(Enum.random(5..15))
    {review.id, texto_limpio}
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

  # ✅ Procesar UNA reseña individual (struct %Review{})
  defp procesar_mensaje(%Review{} = review) do
    IO.puts("\n--- LIMPIEZA DE RESEÑA ##{review.id} ---")
    {id, resumen} = Review.limpiar(review)
    IO.puts("Reseña #{id}: #{resumen}")
    {:ok, id, resumen}
  end

  # ✅ Procesar lista de reseñas (SECUENCIAL)
  defp procesar_lista_secuencial(reseñas) when is_list(reseñas) do
    IO.puts("\n--- LIMPIEZA SECUENCIAL ---")
    Enum.each(reseñas, fn r ->
      {id, resumen} = Review.limpiar(r)
      IO.puts("Reseña #{id}: #{resumen}")
    end)
    :ok
  end

  # ✅ Procesar lista de reseñas (CONCURRENTE)
  defp procesar_lista_concurrente(reseñas) when is_list(reseñas) do
    IO.puts("\n--- LIMPIEZA CONCURRENTE ---")
    tareas = Enum.map(reseñas, fn r ->
      Task.async(fn -> Review.limpiar(r) end)
    end)

    Task.await_many(tareas)
    |> Enum.each(fn {id, resumen} ->
      IO.puts("Reseña #{id}: #{resumen}")
    end)

    :ok
  end
end

NodoServidor.main()
