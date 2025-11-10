defmodule Benchmark do
  def tiempo({modulo, funcion, args}) do
    inicio = System.monotonic_time()
    apply(modulo, funcion, args)
    fin = System.monotonic_time()

    System.convert_time_unit(fin - inicio, :native, :millisecond)
  end

  def mensaje(t1, t2) do
    speedup = Float.round(t1 / t2, 2)

    """
    Tiempo secuencial: #{t1} ms
    Tiempo concurrente: #{t2} ms
    Speedup: x#{speedup}
    """
  end
end
