defmodule Descuento do
  # ----------- 1) Cupón  ----------------
  defp aplicar_cupon(total, nil), do: total
  defp aplicar_cupon(total, "DESC10"), do: total * 0.90
  defp aplicar_cupon(total, "DESC20"), do: total * 0.80
  defp aplicar_cupon(total, _), do: total

  # ----------- 2) Descuento por categoría -----------
  # Bebidas tienen 5% de descuento
  defp descuento_categoria(%Item{categoria: "bebida", precio: p, cantidad: c}),
    do: p * c * 0.95

  # Otras categorías sin descuento
  defp descuento_categoria(%Item{precio: p, cantidad: c}),
    do: p * c

  # ----------- 3) Regla 2x1 -------------------------
  defp descuento_2x1(%Item{cantidad: cant, precio: precio}) when cant >= 2 do
    pares = div(cant, 2)
    impares = rem(cant, 2)
    (pares + impares) * precio
  end

  defp descuento_2x1(%Item{precio: p, cantidad: c}),
    do: p * c

  # ============= FUNCIÓN PRINCIPAL ==================
  def total_con_descuentos(%Carrito{id: id, items: items, cupon: cupon}) do
    :timer.sleep(Enum.random(5..15))  # simula procesamiento

    total_items =
      items
      |> Enum.map(fn item ->
        item
        |> descuento_categoria()
        |> descuento_2x1()
      end)
      |> Enum.sum()

    total_final = aplicar_cupon(total_items, cupon)

    # Convertir a float antes de round
    {id, Float.round(total_final * 1.0, 2)}
  end
end
