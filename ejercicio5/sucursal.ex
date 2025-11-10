defmodule Sucursal do
  defstruct id: 0, ventas: []

  def crear(id, ventas) do
    %Sucursal{id: id, ventas: ventas}
  end

  def total_ventas(%Sucursal{} = sucursal) do
    Enum.sum(sucursal.ventas)
  end
end
