defmodule Orden do
  defstruct id: "", item: "", prep_ms: 0.0

  def crear_orden(id, item, prep_ms) do
    %Orden{id: id, item: item, prep_ms: prep_ms}
  end

  def preparar(%Orden{} = orden) do
    :timer.sleep(orden.prep_ms)
    {:ok, "ticket_#{orden.id}"}
  end
end
