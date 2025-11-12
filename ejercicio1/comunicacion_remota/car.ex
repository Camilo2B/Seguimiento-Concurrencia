defmodule Car do
  defstruct [:id, :piloto, :pit_ms, :vuelta_ms]

  def crear(piloto, vuelta_ms, pit_ms) do
    %Car{
      piloto: piloto,
      vuelta_ms: vuelta_ms,
      pit_ms: pit_ms
    }
  end
end
