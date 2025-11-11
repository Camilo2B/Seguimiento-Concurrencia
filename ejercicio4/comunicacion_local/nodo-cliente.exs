defmodule NodoCliente do

  @nombre_servicio_local :servicio_respuesta
  @servicio_local {@nombre_servicio_local, :nodocliente@cliente}
  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:servicio_cadenas, @nodo_remoto}

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

  @mensajes [
      Review.crear(1, "Excelente atención!"),
      Review.crear(2, "Muy buena comida, pero algo costosa."),
      Review.crear(3, "El lugar es hermoso!"),
      Review.crear(4, "Servicio regular, esperaba más."),
      Review.crear(5, "Recomendado 100%!")
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
