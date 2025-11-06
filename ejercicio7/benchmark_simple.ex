defmodule Benchmark do
  def tiempo({mod, fun, args}) do
    t1 = System.monotonic_time()
    apply(mod, fun, args)
    t2 = System.monotonic_time()

    System.convert_time_unit(t2 - t1, :native, :millisecond)
  end

  def mensaje(t1, t2) do
    speedup = Float.round(t1 / t2, 2)
    "T1: #{t1}ms | T2: #{t2}ms → Speedup = #{speedup}x"
  end
end
