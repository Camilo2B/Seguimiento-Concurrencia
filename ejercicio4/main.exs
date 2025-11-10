Code.require_file("review.ex", _DIR_)

defmodule Main do
  def main() do
    reseñas = [
      Review.crear(1, "Excelente atención!"),
      Review.crear(2, "Muy buena comida, pero algo costosa."),
      Review.crear(3, "El lugar es hermoso!"),
      Review.crear(4, "Servicio regular, esperaba más."),
      Review.crear(5, "Recomendado 100%!")
    ]

    proceso_secuencial(reseñas)
    proceso_concurrente(reseñas)
  end

  # Secuencial
  defp proceso_secuencial(reseñas) do
    IO.puts("\n--- LIMPIEZA SECUENCIAL ---")
    Enum.each(reseñas, fn r ->
      {id, resumen} = Review.limpiar(r)
      IO.puts("Reseña #{id}: #{resumen}")
    end)
  end

  # Concurrente
  defp proceso_concurrente(reseñas) do
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

Main.main()
