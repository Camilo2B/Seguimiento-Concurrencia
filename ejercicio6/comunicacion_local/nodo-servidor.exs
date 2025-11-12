defmodule Usuario do
  defstruct correo: "", edad: 0, nombre: ""

  def crear(correo, edad, nombre) do
    %Usuario{
      correo: correo,
      edad: edad,
      nombre: nombre
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

  defp procesar_mensaje(%Usuario{correo: correo, edad: edad, nombre: nombre}) do

    :timer.sleep(Enum.random(3..10))

    errores = []

    errores =
      if String.contains?(correo, "@"), do: errores, else: ["Email inválido" | errores]

    errores =
      if edad >= 0, do: errores, else: ["Edad inválida" | errores]

    errores =
      if String.trim(nombre) != "", do: errores, else: ["Nombre vacío" | errores]

    if errores == [] do
      {correo, :ok}
    else
      {correo, {:error, Enum.reverse(errores)}}
    end
  end

  defp procesar_mensaje(lista_usuarios) do
    Enum.map(lista_usuarios, &procesar_mensaje/1)
  end

  defp procesar_mensaje(lista_usuarios) do
    lista_usuarios
    |> Task.async_stream(&procesar_mensaje/1,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.map(fn {:ok, resultado} -> resultado end)
  end
end

NodoServidor.main()
