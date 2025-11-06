defmodule Procesador do
  def procesar_secuencial(lista) do
    Enum.map(lista, &Render.render/1)
  end

  def procesar_concurrente(lista) do
    lista
    |> Task.async_stream(&Render.render/1,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.map(fn {:ok, res} -> res end)
  end
end
