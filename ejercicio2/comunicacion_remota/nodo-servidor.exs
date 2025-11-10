defmodule NodoServidor do

  @nodo_servidor :"servidor@192.168.137.1"
  @nombre_proceso :servicio_cadenas

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

  defp procesar_mensaje(%Producto{nombre: nombre, stock: stock, precio_sin_iva: psi, iva: iva}) do
    precio_final =
      Enum.map(fn _, acc ->
        :timer.sleep(5000)
        psi * (1 + iva)
      end)
      IO.puts("#{nombre} tiene un precio final de #{precio_final}")
      {nombre, precio_final}
  end

   defp procesar_mensaje(productos) do
    Enum.map(productos, &procesar_mensaje/1)
    |> Enum.sort_by(fn {_nombre, precio} -> precio end)
  end

  defp procesar_mensaje(productos) do

    Enum.map(productos, fn producto ->

    Task.async(fn -> procesar_mensaje(producto) end)
    end)
    |> Task.await_many()
    |> Enum.sort_by(fn {_nombre, precio} -> precio end)
  end
end

NodoServidor.main()
