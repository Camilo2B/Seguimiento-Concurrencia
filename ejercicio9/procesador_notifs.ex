defmodule ProcesadorNotifs do
  def procesar_secuencial(lista) do
    t0 = System.monotonic_time(:millisecond)

    resultados =
      lista
      |> Enum.map(&Notif.enviar/1)

    total = System.monotonic_time(:millisecond) - t0
    {resultados, total}
  end

  def procesar_concurrente(lista) do
    t0 = System.monotonic_time(:millisecond)

    resultados =
      lista
      |> Task.async_stream(&Notif.enviar/1,
        max_concurrency: System.schedulers_online(),
        timeout: :infinity
      )
      |> Enum.map(fn {:ok, r} -> r end)

    total = System.monotonic_time(:millisecond) - t0
    {resultados, total}
  end
end
