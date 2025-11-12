defmodule Main do
  def main() do
    ordenes = [
      Orden.crear_orden(1, "Capuchino", 300),
      Orden.crear_orden(2, "Latte", 400),
      Orden.crear_orden(3, "Tostadas", 250),
      Orden.crear_orden(4, "Jugo de naranja", 350),
      Orden.crear_orden(5, "Croissant", 500)
    ]

    proceso_secuencial(ordenes)
    proceso_concurrente(ordenes)
  end

  # Secuencial
  defp proceso_secuencial(ordenes) do
    IO.puts("\n--- PROCESO SECUENCIAL ---")
    Enum.each(ordenes, fn orden ->
      resultado = Orden.preparar(orden)
      IO.puts(resultado)
    end)
  end

  # Concurrente
  defp proceso_concurrente(ordenes) do
    IO.puts("\n--- PROCESO CONCURRENTE ---")
    tareas = Enum.map(ordenes, fn orden ->
      Task.async(fn -> Orden.preparar(orden) end)
    end)

    Task.await_many(tareas)
    |> Enum.each(&IO.puts/1)
  end
end

Main.main()
