defmodule Benchmark do
  def determinar_tiempo_ejecucion({modulo, funcion, args}) do
    t_in = System.monotonic_time()
    apply(modulo, funcion, args)
    t_fin = System.monotonic_time()

    System.convert_time_unit(t_fin - t_in, :native, :millisecond)
  end

  def generar_mensaje(t1, t2) do
    speedup = Float.round(t1 / t2, 2)

    """
    ---- Benchmark ----
    Tiempo secuencial:  #{t1} ms
    Tiempo concurrente: #{t2} ms
    Speedup: #{speedup}x
    -------------------
    """
  end
end
