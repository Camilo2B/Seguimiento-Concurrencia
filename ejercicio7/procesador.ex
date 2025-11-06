defmodule Procesador do
  def procesar_secuencial(carritos) do
    Enum.map(carritos, &Descuento.total_con_descuentos/1)
  end

  def procesar_concurrente(carritos) do
    carritos
    |> Task.async_stream(&Descuento.total_con_descuentos/1,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.map(fn {:ok, r} -> r end)
  end
end
