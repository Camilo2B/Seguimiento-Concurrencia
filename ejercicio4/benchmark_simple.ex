defmodule BenchmarkSimple do
  def medir({mod, fun, args}) do
    t0 = System.monotonic_time()
    result = apply(mod, fun, args)
    t1 = System.monotonic_time()

    micros =
      System.convert_time_unit(t1 - t0, :native, :microsecond)

    {micros, result}
  end
end
