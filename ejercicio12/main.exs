defmodule Main do
  def main() do
    plantillas = [
      Tpl.crear_tpl(1, "Hola {{nombre}}, tu pedido está listo.", %{nombre: "Ana", id: 123}),
      Tpl.crear_tpl(2, "Estimado {{cliente}}, su total es ${{total}}.", %{cliente: "Carlos", total: 45.99}),
      Tpl.crear_tpl(3, "Gracias {{usuario}} por registrarte en {{app}}.", %{usuario: "Sofía", app: "MiApp"}),
      Tpl.crear_tpl(4, "Hola {{nombre}}, recuerda tu cita el {{fecha}}.", %{nombre: "Luis", fecha: "10/11/2025"})
    ]

    proceso_secuencial(plantillas)
    proceso_concurrente(plantillas)
  end

  # --- SECUENCIAL ---
  defp proceso_secuencial(plantillas) do
    IO.puts("\n--- RENDER SECUENCIAL ---")
    Enum.each(plantillas, fn tpl ->
      renderizado = Tpl.render(tpl)
      IO.puts("Plantilla #{tpl.id}: #{renderizado}")
    end)
  end

  # --- CONCURRENTE ---
  defp proceso_concurrente(plantillas) do
    IO.puts("\n--- RENDER CONCURRENTE ---")
    tareas = Enum.map(plantillas, fn tpl ->
      Task.async(fn -> {tpl.id, Tpl.render(tpl)} end)
    end)

    Task.await_many(tareas)
    |> Enum.each(fn {id, renderizado} ->
      IO.puts("Plantilla #{id}: #{renderizado}")
    end)
  end
end

Main.main()
