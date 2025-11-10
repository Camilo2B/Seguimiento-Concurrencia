Code.require_file("sucursal.ex", _DIR_)

defmodule Main do
  def main() do
    sucursales = [
      Sucursal.crear(1, [100, 200, 300]),
      Sucursal.crear(2, [150, 250, 350]),
      Sucursal.crear(3, [200, 300, 400])
    ]

    proceso_secuencial(sucursales)
    proceso_concurrente(sucursales)
  end

  defp proceso_secuencial(sucursales) do
    IO.puts("\n--- PROCESO SECUENCIAL ---")
    Enum.each(sucursales, fn s ->
      total = Sucursal.total_ventas(s)
      IO.puts("Sucursal #{s.id}: total de ventas = #{total}")
    end)
  end

  defp proceso_concurrente(sucursales) do
    IO.puts("\n--- PROCESO CONCURRENTE ---")
    tareas = Enum.map(sucursales, fn s ->
      Task.async(fn -> {s.id, Sucursal.total_ventas(s)} end)
    end)

    Task.await_many(tareas)
    |> Enum.each(fn {id, total} ->
      IO.puts("Sucursal #{id}: total de ventas = #{total}")
    end)
  end
end

Main.main()
