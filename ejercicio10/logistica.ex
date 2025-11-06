defmodule Logistica do
  # Tiempos simulados
  @t_etiquetar 200
  @t_pesar     300
  @t_embalar_normal 400
  @t_embalar_fragil 700

  def preparar(%Paquete{id: id, peso: peso, fragil: fragil} = paquete) do
    inicio = System.monotonic_time(:millisecond)

    # 1) Etiquetar
    :timer.sleep(@t_etiquetar)

    # 2) Pesar
    :timer.sleep(@t_pesar)

    # 3) Embalar
    if fragil do
      :timer.sleep(@t_embalar_fragil)
    else
      :timer.sleep(@t_embalar_normal)
    end

    fin = System.monotonic_time(:millisecond)

    {id, fin - inicio}
  end
end
