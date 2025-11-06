defmodule Tpl do
  defstruct [:id, :nombre, :vars]   # ejemplo: %{id: 1, nombre: "Hola {{user}}", vars: %{user: "Juan"}}
end
