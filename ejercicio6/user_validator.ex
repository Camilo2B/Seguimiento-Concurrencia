defmodule UserValidator do
  def validar(%User{email: email, edad: edad, nombre: nombre}) do
    # Simula trabajo pesado
    :timer.sleep(Enum.random(3..10))

    errores = []

    # Validación del correo
    errores =
      if String.contains?(email, "@"), do: errores, else: ["Email inválido" | errores]

    # Validación de edad
    errores =
      if edad >= 0, do: errores, else: ["Edad inválida" | errores]

    # Validación del nombre
    errores =
      if String.trim(nombre) != "", do: errores, else: ["Nombre vacío" | errores]

    if errores == [] do
      {email, :ok}
    else
      {email, {:error, Enum.reverse(errores)}}
    end
  end
end
