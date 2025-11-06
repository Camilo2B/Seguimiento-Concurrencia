defmodule Main do
  def run(carritos) do
    t1 = Benchmark.tiempo({Procesador, :procesar_secuencial, [carritos]})
    t2 = Benchmark.tiempo({Procesador, :procesar_concurrente, [carritos]})

    IO.inspect(Procesador.procesar_concurrente(carritos), label: "Resultados")
    IO.puts Benchmark.mensaje(t1, t2)
  end
end

carritos = [
  %Carrito{
    id: 1,
    cupon: "DESC10",
    items: [
      %Item{nombre: "Café", categoria: "bebida", precio: 3000, cantidad: 2},
      %Item{nombre: "Pan", categoria: "comida", precio: 1500, cantidad: 1}
    ]
  },
  %Carrito{
    id: 2,
    cupon: nil,
    items: [
      %Item{nombre: "Jugo", categoria: "bebida", precio: 2500, cantidad: 3},
      %Item{nombre: "Galletas", categoria: "dulce", precio: 1000, cantidad: 2}
    ]
  },
  %Carrito{
    id: 3,
    cupon: "DESC20",
    items: [
      %Item{nombre: "Chocolate", categoria: "dulce", precio: 5000, cantidad: 1},
      %Item{nombre: "Té", categoria: "bebida", precio: 2000, cantidad: 2}
    ]
  }
]

Main.run(carritos)
