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


defmodule NodoCliente do

  @nodo_cliente :"cliente@192.168.137.239"
  @nodo_servidor :"servidor@192.168.137.239"
  @nombre_proceso :servicio_cadenas

 @mensajes [
    %Car{id: 1, piloto: "Hamilton", vuelta_ms: 800, pit_ms: 400},
      %Car{id: 2, piloto: "Verstappen", vuelta_ms: 750, pit_ms: 300},
      %Car{id: 3, piloto: "Alonso", vuelta_ms: 820, pit_ms: 500},
      %Car{id: 4, piloto: "Leclerc", vuelta_ms: 790, pit_ms: 350}
  ]

  def main() do
    IO.puts("SE INICIA EL CLIENTE")
    iniciar_nodo(@nodo_cliente)
    establecer_conexion(@nodo_servidor)
    |> iniciar_produccion()
  end

  defp iniciar_nodo(nombre) do
    Node.start(nombre)
    Node.set_cookie(:my_cookie)
  end

  defp establecer_conexion(nodo_remoto) do
    Node.connect(nodo_remoto)
  end

  defp iniciar_produccion(false), do: IO.puts("No se pudo conectar con el nodo servidor")

  defp iniciar_produccion(true) do
    enviar_mensajes()
    recibir_respuestas()
  end

  defp enviar_mensajes() do
    Enum.each(@mensajes, &enviar_mensaje/1)
  end

  defp enviar_mensaje(mensaje) do
    send({@nombre_proceso, @nodo_servidor}, {self(), mensaje})
  end

  defp recibir_respuestas() do
    receive do
      :fin -> :ok
      respuesta ->
        IO.puts("\t -> \"#{inspect(respuesta)}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
