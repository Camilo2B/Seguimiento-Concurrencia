defmodule NodoCliente do

  @nodo_cliente :"cliente@192.168.137.239"
  @nodo_servidor :"servidor@192.168.137.239"
  @nombre_proceso :servicio_cadenas

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
        IO.puts("\t -> \"#{respuesta}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
