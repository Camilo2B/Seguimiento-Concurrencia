defmodule Orden do
  defstruct id: 0, item: "", prep_ms: 0

  def crear_orden(id, item, prep_ms) do
    %Orden{id: id, item: item, prep_ms: prep_ms}
  end

  def preparar(%Orden{} = orden) do
    :timer.sleep(orden.prep_ms)
    "Ticket listo para #{orden.item}"
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

  # ✅ NUEVA CLÁUSULA: Procesar una orden individual
  defp procesar_mensaje(%Orden{} = orden) do
    IO.puts("\n--- PROCESANDO ORDEN ##{orden.id} ---")
    resultado = Orden.preparar(orden)
    IO.puts(resultado)
    {:ok, orden.id, orden.item}
  end

  # Procesar un producto
  defp procesar_mensaje(%{nombre: nombre, stock: stock, precio_sin_iva: precio, iva: iva}) do
    precio_con_iva = precio * (1 + iva)
    precio_total = precio_con_iva * stock

    resultado = """
    Producto: #{nombre}
    Stock: #{stock}
    Precio sin IVA: $#{:erlang.float_to_binary(precio, decimals: 2)}
    IVA (#{trunc(iva * 100)}%): $#{:erlang.float_to_binary(precio * iva, decimals: 2)}
    Precio con IVA: $#{:erlang.float_to_binary(precio_con_iva, decimals: 2)}
    Valor Total Inventario: $#{:erlang.float_to_binary(precio_total, decimals: 2)}
    """

    IO.puts("\n--- PROCESANDO PRODUCTO ---")
    IO.puts(resultado)

    {nombre, :ok}
  end

  # Procesar lista de órdenes (secuencial)
  defp procesar_mensaje_secuencial(ordenes) when is_list(ordenes) do
    IO.puts("\n--- PROCESO SECUENCIAL ---")
    Enum.each(ordenes, fn orden ->
      resultado = Orden.preparar(orden)
      IO.puts(resultado)
    end)
    :ok
  end

  # Procesar lista de órdenes (concurrente)
  defp procesar_mensaje_concurrente(ordenes) when is_list(ordenes) do
    IO.puts("\n--- PROCESO CONCURRENTE ---")
    tareas = Enum.map(ordenes, fn orden ->
      Task.async(fn -> Orden.preparar(orden) end)
    end)

    Task.await_many(tareas)
    |> Enum.each(&IO.puts/1)

    :ok
  end
end

NodoServidor.main()


