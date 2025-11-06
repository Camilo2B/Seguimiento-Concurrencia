defmodule Main do
  def run(_) do
    lotes = [
      %Paquete{id: 1, peso: 2.3, fragil: false},
      %Paquete{id: 2, peso: 1.1, fragil: true},
      %Paquete{id: 3, peso: 4.0, fragil: false},
      %Paquete{id: 4, peso: 0.5, fragil: true},
      %Paquete{id: 5, peso: 3.2, fragil: false}
    ]

    IO.puts("---- SEC cuántico ----")
    {res_sec, t_sec} = Benchmark.tiempo(fn ->
      Enum.map(lotes, &Logistica.preparar/1)
    end)
    IO.inspect(res_sec)
    IO.puts("Tiempo secuencial: #{t_sec} ms\n")

    IO.puts("---- CONCURRENTE ----")
    {res_conc, t_conc} = Benchmark.tiempo(fn ->
      lotes
      |> Enum.map(fn paquete ->
        Task.async(fn -> Logistica.preparar(paquete) end)
      end)
      |> Enum.map(&Task.await/1)
    end)
    IO.inspect(res_conc)
    IO.puts("Tiempo concurrente: #{t_conc} ms\n")

    speedup = Float.round(t_sec / t_conc, 2)
    IO.puts("SPEEDUP: x#{speedup}")
  end
end

Main.run([])
