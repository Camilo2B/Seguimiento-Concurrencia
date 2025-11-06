defmodule CalculoIva do

  def calcular_precio_final(%Producto{nombre: nombre, stock: stock, precio_sin_iva: psi, iva: iva}) do
    precio_final =
      Enum.map(fn _, acc ->
          :timer.sleep(5000)
          psi * (1 + iva)
      end)
      IO.puts("#{nombre} tiene un precio final de #{precio_final}")
      {nombre, precio_final}
  end

  def precio_secuencial(productos) do
    Enum.map(productos, &calcular_precio_final/1)
    |> Enum.sort_by(fn {_nombre, precio} -> precio end)
  end

  def precio_concurrente(productos) do

    Enum.map(productos, fn producto ->

    Task.async(fn -> calcular_precio_final(producto) end)
    end)
    |> Task.await_many()
    |> Enum.sort_by(fn {_nombre, precio} -> precio end)
  end

  def lista_productos do
    [
  %Producto{nombre: "Camisa Blanca", stock: 18, precio_sin_iva: 150000, iva: 0.19},
  %Producto{nombre: "Pantalones Vaqueros", stock: 25, precio_sin_iva: 200000, iva: 0.16},
  %Producto{nombre: "Chaqueta de Cuero", stock: 10, precio_sin_iva: 450000, iva: 0.20},
  %Producto{nombre: "Sombrero de Lana", stock: 30, precio_sin_iva: 80000, iva: 0.10},
  %Producto{nombre: "Bufanda Roja", stock: 15, precio_sin_iva: 50000, iva: 0.12},
  %Producto{nombre: "Guantes de Invierno", stock: 20, precio_sin_iva: 60000, iva: 0.15},
  %Producto{nombre: "Bolso de Mano", stock: 12, precio_sin_iva: 300000, iva: 0.18},
  %Producto{nombre: "Reloj Analógico", stock: 8, precio_sin_iva: 250000, iva: 0.22},
  %Producto{nombre: "Pulsera de Plata", stock: 22, precio_sin_iva: 100000, iva: 0.14},
  %Producto{nombre: "Collar de Perlas", stock: 16, precio_sin_iva: 180000, iva: 0.17},
  %Producto{nombre: "Aretes Dorados", stock: 19, precio_sin_iva: 70000, iva: 0.13},
  %Producto{nombre: "Botas de Montaña", stock: 14, precio_sin_iva: 350000, iva: 0.21},
  %Producto{nombre: "Sandalias de Playa", stock: 28, precio_sin_iva: 90000, iva: 0.11},
  %Producto{nombre: "Gorra Deportiva", stock: 26, precio_sin_iva: 40000, iva: 0.09},
  %Producto{nombre: "Cinturón de Cuero", stock: 17, precio_sin_iva: 120000, iva: 0.19},
  %Producto{nombre: "Mochila Escolar", stock: 21, precio_sin_iva: 220000, iva: 0.16},
  %Producto{nombre: "Lentes de Lectura", stock: 13, precio_sin_iva: 60000, iva: 0.15},
  %Producto{nombre: "Bufanda de Seda", stock: 11, precio_sin_iva: 140000, iva: 0.20},
  %Producto{nombre: "Chaleco Deportivo", stock: 24, precio_sin_iva: 160000, iva: 0.18},
  %Producto{nombre: "Calcetines de Algodón", stock: 32, precio_sin_iva: 20000, iva: 0.10}
    ]
  end

  def iniciar do
    productos = lista_productos()

    precio_final1 = precio_secuencial(productos)
    IO.puts("\nPrecio Secuencial:")
    Enum.each(precio_final1, fn {nombre, precio} -> precio end)
  end

end
