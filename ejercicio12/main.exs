defmodule Main do
  def run(lote) do
    t1 = Benchmark.tiempo({Procesador, :procesar_secuencial, [lote]})
    t2 = Benchmark.tiempo({Procesador, :procesar_concurrente, [lote]})

    IO.inspect(t2 |> elem(1), label: "Resultados")
    IO.puts Benchmark.mensaje(t1, t2)
  end
end

lote = [
  %Tpl{
    id: 1,
    nombre: "Hola {{user}}, tu pedido {{id}} está listo.",
    vars: %{user: "Juan", id: 991}
  },
  %Tpl{
    id: 2,
    nombre: "<p>Estimado {{user}}, su saldo es {{saldo}} COP</p>",
    vars: %{user: "Maria", saldo: 120_000}
  },
  %Tpl{
    id: 3,
    nombre: """
    <div>
      <h1>Hola {{user}}</h1>
      <p>Gracias por registrarte. Tu código es {{codigo}}</p>
    </div>
    """,
    vars: %{user: "Carlos", codigo: "A9F21"}
  }
]

Main.run(lote)
