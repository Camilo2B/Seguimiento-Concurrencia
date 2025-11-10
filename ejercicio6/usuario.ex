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
