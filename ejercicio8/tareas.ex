defmodule Tareas do
  # Simula ejecutar una tarea de mantenimiento
  def ejecutar(:reindex) do
    :timer.sleep(4000)
    {:ok, "Reindex OK"}
  end

  def ejecutar(:purge_cache) do
    :timer.sleep(2000)
    {:ok, "Purge Cache OK"}
  end

  def ejecutar(:build_sitemap) do
    :timer.sleep(3000)
    {:ok, "Sitemap OK"}
  end

  def ejecutar(:clean_logs) do
    :timer.sleep(1500)
    {:ok, "Clean Logs OK"}
  end

  def ejecutar(:send_emails) do
    :timer.sleep(2500)
    {:ok, "Send Emails OK"}
  end

  def ejecutar(x) do
    {:error, "Tarea desconocida: #{inspect(x)}"}
  end
end
