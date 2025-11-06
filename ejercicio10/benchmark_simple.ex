defmodule Benchmark do
  def tiempo(fun) do
    inicio = System.monotonic_time(:millisecond)
    r = fun.()
    fin = System.monotonic_time(:millisecond)
    {r, fin - inicio}
  end
end
