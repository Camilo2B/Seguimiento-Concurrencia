defmodule ValidacionUsuario do
  def validar(%Usuario{correo: correo, edad: edad, nombre: nombre}) do

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
end
