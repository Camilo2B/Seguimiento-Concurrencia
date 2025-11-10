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
