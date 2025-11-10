defmodule Benchmark do
  def medir() do
    lote = [:reindex, :purge_cache, :build_sitemap, :send_emails, :clean_logs]

    IO.puts("Ejecutando secuencial...")
    {res_s, tiempo_s} = Backoffice.run_secuencial(lote)

    IO.puts("Ejecutando concurrente...")
    {res_c, tiempo_c} = Backoffice.run_concurrente(lote)

    IO.puts("\nResultados:")
    IO.inspect(res_s, label: "Secuencial")
    IO.inspect(res_c, label: "Concurrente")

    IO.puts("\nTiempo secuencial: #{tiempo_s} ms")
    IO.puts("Tiempo concurrente: #{tiempo_c} ms")

    speedup = Float.round(tiempo_s / tiempo_c, 2)
    IO.puts("Speedup: x#{speedup}")
  end
end
