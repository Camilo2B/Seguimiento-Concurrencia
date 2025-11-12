defmodule Producto do
  defstruct [:nombre, :stock, :precio_sin_iva, :iva]

  def crear(nombre, stock, precio_sin_iva, iva) do
    %Producto{
      nombre: nombre,
      stock: stock,
      precio_sin_iva: precio_sin_iva,
      iva: iva
    }
  end
end
