defmodule Cafeteria do
  alias Cocina

  def correr_benchmark(ordenes) do
    t1 = Benchmark.determinar_tiempo_ejecucion({Cocina, :procesar_secuencial, [ordenes]})

    t2 = Benchmark.determinar_tiempo_ejecucion({Cocina, :procesar_concurrente, [ordenes]})

    IO.puts Benchmark.generar_mensaje(t1, t2)
  end
end

  ordenes = [
  Orden.crear_orden(1, "Café", 1000),
  Orden.crear_orden(2, "Té", 1500),
  Orden.crear_orden(3, "Capuchino", 2000),
  Orden.crear_orden(4, "Chocolate", 1200)
]

Cafeteria.correr_benchmark(ordenes)
