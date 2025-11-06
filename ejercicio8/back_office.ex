defmodule Backoffice do
  def run_secuencial(tareas) do
    tiempo_inicial = System.monotonic_time(:millisecond)

    resultados =
      tareas
      |> Enum.map(&Tareas.ejecutar/1)

    total = System.monotonic_time(:millisecond) - tiempo_inicial
    {resultados, total}
  end

    def run_concurrente(tareas) do
    tiempo_inicial = System.monotonic_time(:millisecond)

    resultados =
      tareas
      |> Task.async_stream(&Tareas.ejecutar/1, timeout: :infinity)
      |> Enum.map(fn {:ok, r} -> r end)

    total = System.monotonic_time(:millisecond) - tiempo_inicial
    {resultados, total}
  end
end
