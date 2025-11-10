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
