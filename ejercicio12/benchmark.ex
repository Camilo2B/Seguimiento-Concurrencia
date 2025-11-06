defmodule Benchmark do
  def tiempo(fun_tuple) do
    {mod, fun, args} = fun_tuple
    inicio = System.monotonic_time(:millisecond)
    resultado = apply(mod, fun, args)
    fin = System.monotonic_time(:millisecond)
    {fin - inicio, resultado}
  end

  def mensaje({t1, _}, {t2, _}) do
    speedup = Float.round(t1 / t2, 2)
    """
    Secuencial: #{t1} ms
    Concurrente: #{t2} ms
    Speedup: x#{speedup}
    """
  end
end
