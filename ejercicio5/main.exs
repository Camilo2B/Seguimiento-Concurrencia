defmodule SucursalesApp do
  alias ProcesadorReportes
  alias Benchmark

  def correr(sucursales) do
    t1 = Benchmark.tiempo({ProcesadorReportes, :procesar_secuencial, [sucursales]})
    t2 = Benchmark.tiempo({ProcesadorReportes, :procesar_concurrente, [sucursales]})

    IO.puts Benchmark.mensaje(t1, t2)
  end
end

sucursales = [
  Sucursal.crear(1, [100, 200, 150, 80]),
  Sucursal.crear(2, [120, 180, 90, 160]),
  Sucursal.crear(3, [300, 250, 100, 120]),
  Sucursal.crear(4, [80, 60, 110, 95]),
  Sucursal.crear(5, [200, 210, 190, 220])
]

SucursalesApp.correr(sucursales)
