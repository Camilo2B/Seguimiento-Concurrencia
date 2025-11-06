defmodule BenchmarkNotifs do
  def medir() do
    lista = [
      %Notif{canal: :email, usuario: "ana", plantilla: "bienvenida"},
      %Notif{canal: :sms, usuario: "juan", plantilla: "alerta"},
      %Notif{canal: :push, usuario: "maria", plantilla: "promo"},
      %Notif{canal: :email, usuario: "sofia", plantilla: "recordatorio"},
      %Notif{canal: :push, usuario: "diego", plantilla: "news"}
    ]

    {res_s, ts} = ProcesadorNotifs.procesar_secuencial(lista)
    {res_c, tc} = ProcesadorNotifs.procesar_concurrente(lista)

    IO.puts("Resultados secuencial:")
    IO.inspect(res_s)

    IO.puts("\nResultados concurrente:")
    IO.inspect(res_c)

    IO.puts("\nTiempo secuencial: #{ts} ms")
    IO.puts("Tiempo concurrente: #{tc} ms")

    speed = Float.round(ts / tc, 2)
    IO.puts("Speedup: x#{speed}")
  end
end
