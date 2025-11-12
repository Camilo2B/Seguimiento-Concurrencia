# Definir Car como módulo separado
defmodule Car do
  defstruct [:id, :piloto, :pit_ms, :vuelta_ms]

  def crear(piloto, vuelta_ms, pit_ms) do
    %Car{
      piloto: piloto,
      vuelta_ms: vuelta_ms,
      pit_ms: pit_ms
    }
  end
end

defmodule NodoServidor do
  @nombre_servicio_local :servicio_cadenas
  @vueltas 5  # Definir el número de vueltas

  def main() do
    IO.puts("PROCESO SECUNDARIO")
    registrar_servicio(@nombre_servicio_local)
    procesar_mensajes()
  end

  defp registrar_servicio(nombre_servicio_local),
    do: Process.register(self(), nombre_servicio_local)

  defp procesar_mensajes() do
    receive do
      {productor, mensaje} ->
        respuesta = procesar_mensaje(mensaje)
        send(productor, respuesta)

        if respuesta != :fin, do: procesar_mensajes()
    end
  end

  defp procesar_mensaje(:fin), do: :fin

  defp procesar_mensaje(%Car{piloto: piloto, vuelta_ms: vms, pit_ms: pms}) do
    total =
      Enum.reduce(1..@vueltas, 0, fn _, acc ->
        :timer.sleep(vms)
        acc + vms
      end)

    total_total = total + pms
    IO.puts("#{piloto} terminó con #{total_total} ms.")
    {piloto, total_total}
  end
end

NodoServidor.main()


