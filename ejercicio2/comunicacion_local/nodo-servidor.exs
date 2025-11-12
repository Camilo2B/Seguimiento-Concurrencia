defmodule Producto do
  defstruct [:nombre, :stock, :precio_sin_iva, :iva]

  def crear(nombre, stock, precio_sin_iva, iva) do
    %Producto{
      nombre: nombre,
      stock: stock,
      precio_sin_iva: precio_sin_iva,
      iva: iva
    }
  end
end


defmodule NodoServidor do
  @nombre_servicio_local :servicio_cadenas

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

  defp procesar_mensaje(%Producto{nombre: nombre, stock: _stock, precio_sin_iva: psi, iva: iva}) do
    # Simular procesamiento con sleep
    :timer.sleep(5000)

    precio_final = psi * (1 + iva)

    IO.puts("#{nombre} tiene un precio final de #{precio_final}")
    {nombre, precio_final}
  end

  defp procesar_mensaje(productos) do
    Enum.map(productos, &procesar_mensaje/1)
    |> Enum.sort_by(fn {_nombre, precio} -> precio end)
  end

end

NodoServidor.main()
