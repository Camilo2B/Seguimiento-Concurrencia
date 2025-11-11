defmodule Tpl do
  defstruct id: 0, nombre: "", vars: %{}

  # Crea una nueva plantilla
  def crear_tpl(id, nombre, vars) do
    %Tpl{id: id, nombre: nombre, vars: vars}
  end

  # Renderiza la plantilla reemplazando variables {{clave}} por su valor
  def render(%Tpl{} = tpl) do
    # simulamos el costo según tamaño del texto
    :timer.sleep(String.length(tpl.nombre) * 5)

    Enum.reduce(tpl.vars, tpl.nombre, fn {clave, valor}, acc ->
      String.replace(acc, "{{#{clave}}}", to_string(valor))
    end)
  end
end
