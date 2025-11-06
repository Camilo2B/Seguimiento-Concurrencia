defmodule Moderacion do
  # Lista de palabras prohibidas (ejemplo simple)
  @prohibidas ["idiota", "estúpido", "rata", "maldito"]

  # Reglas de moderación:
  # - no puede tener palabras prohibidas
  # - longitud mínima 5
  # - no puede tener links (http)
  defp verificar_reglas(texto) do
    cond do
      String.length(texto) < 5 ->
        :rechazado

      texto |> String.downcase() |> contiene?(@prohibidas) ->
        :rechazado

      String.contains?(texto, "http") ->
        :rechazado

      true ->
        :aprobado
    end
  end

  # Auxiliar: Detectar si un texto contiene alguna palabra de una lista
  defp contiene?(texto, lista) do
    Enum.any?(lista, fn palabra ->
      String.contains?(texto, palabra)
    end)
  end

  # ===== FUNCIÓN PRINCIPAL DEL EJERCICIO =====
  def moderar(%Comentario{id: id, texto: texto}) do
    # Simulación de procesamiento: el enunciado dice 5..12 ms
    :timer.sleep(Enum.random(5..12))

    resultado = verificar_reglas(texto)

    {id, resultado}
  end
end
