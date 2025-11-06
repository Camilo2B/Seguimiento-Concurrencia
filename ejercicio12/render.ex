defmodule Render do
  # Renderiza una mini-plantilla string con variables {{var}}

  def render(%Tpl{id: id, nombre: plantilla, vars: vars}) do
    # Simula costo según tamaño
    sleep_time = trunc(String.length(plantilla) * 1.2)
    :timer.sleep(sleep_time)

    html =
      Enum.reduce(vars, plantilla, fn {clave, valor}, acc ->
        String.replace(acc, "{{#{clave}}}", to_string(valor))
      end)

    {id, html}
  end
end
