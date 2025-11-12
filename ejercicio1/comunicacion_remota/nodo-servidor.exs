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

  @nodo_servidor :"servidor@192.168.137.239"
  @nombre_proceso :servicio_cadenas
  @vueltas 5  # Definir el número de vueltas


  def main() do
    IO.puts("SE INICIA EL SERVIDOR")
    iniciar_nodo(@nodo_servidor)
    registrar_servicio(@nombre_proceso)
    procesar_mensajes()
  end

  def iniciar_nodo(nombre) do
    Node.start(nombre)
    Node.set_cookie(:my_cookie)
  end

  defp registrar_servicio(nombre_servicio_local), do:
    Process.register(self(), nombre_servicio_local)

  defp procesar_mensajes() do
    receive do
      {productor, :fin} ->
        send(productor, :fin)
      {productor, mensaje} ->
        respuesta = procesar_mensaje(mensaje)
        send(productor, respuesta)
        procesar_mensajes()
    end
  end

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
