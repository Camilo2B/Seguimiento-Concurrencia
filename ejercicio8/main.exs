defmodule Main do
  def run(8) do
    Benchmark.medir()
  end

  def run(_) do
    IO.puts("Ejercicio no implementado.")
  end
end

Main.run(8)
