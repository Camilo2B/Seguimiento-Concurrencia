defmodule Cocina do
  def procesar_secuencial(ordenes) do
    Enum.map(ordenes, fn orden ->
      Orden.preparar(orden)
    end)
  end

  def procesar_concurrente(ordenes) do
    ordenes
    |> Enum.map(fn orden ->
      Task.async(fn -> Orden.preparar(orden) end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))
  end
end
