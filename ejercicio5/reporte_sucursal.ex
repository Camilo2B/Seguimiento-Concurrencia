defmodule ReporteSucursal do
  def generar(%Sucursal{id: id, ventas_diarias: ventas}) do
    # Simular trabajo pesado
    :timer.sleep(Enum.random(50..120))

    total = Enum.sum(ventas)
    promedio = total / max(length(ventas), 1)

    IO.puts("Reporte listo Sucursal #{id}")

    %{
      id: id,
      total_ventas: total,
      promedio_diario: promedio
    }
  end
end
