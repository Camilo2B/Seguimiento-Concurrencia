Code.require_file("comentario.ex")
Code.require_file("moderacion.ex")
Code.require_file("benchmark_simple.ex")

lote = [
  %Comentario{id: 1, texto: "Hola amigo!"},
  %Comentario{id: 2, texto: "Eres un idiota"},
  %Comentario{id: 3, texto: "Visita mi web http://spam.com"},
  %Comentario{id: 4, texto: "Buen trabajo"},
  %Comentario{id: 5, texto: "rata inmunda"},
  %Comentario{id: 6, texto: "Ok"},
  %Comentario{id: 7, texto: "Excelente servicio!"}
]

# ===== Secuencial =====
{res_sec, t_sec} = Benchmark.tiempo(fn ->
  Enum.map(lote, &Moderacion.moderar/1)
end)

IO.puts("Secuencial:")
IO.inspect(res_sec)
IO.puts("Tiempo: #{t_sec} ms\n")

# ===== Concurrente =====
{res_conc, t_conc} = Benchmark.tiempo(fn ->
  lote
  |> Enum.map(fn c ->
    Task.async(fn -> Moderacion.moderar(c) end)
  end)
  |> Enum.map(&Task.await/1)
end)

IO.puts("Concurrente:")
IO.inspect(res_conc)
IO.puts("Tiempo: #{t_conc} ms\n")

speedup = Float.round(t_sec / t_conc, 2)
IO.puts("SPEEDUP: x#{speedup}")
