defmodule User do
  defstruct email: "", edad: 0, nombre: ""

  def crear(email, edad, nombre) do
    %User{email: email, edad: edad, nombre: nombre}
  end
end
