defmodule ProcesadorReportes do
  alias ReporteSucursal

  def procesar_secuencial(sucursales) do
    Enum.map(sucursales, &ReporteSucursal.generar/1)
  end

  def procesar_concurrente(sucursales) do
    sucursales
    |> Enum.map(fn suc ->
      Task.async(fn -> ReporteSucursal.generar(suc) end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))
  end
end
