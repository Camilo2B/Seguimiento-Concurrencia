defmodule Sucursal do
  defstruct id: nil, ventas_diarias: []

  def crear(id, ventas_diarias) do
    %Sucursal{id: id, ventas_diarias: ventas_diarias}
  end
end
