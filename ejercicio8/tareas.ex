defmodule TareasBackoffice do

  def ejecutar(:reindex) do
    :timer.sleep(3500)
    {:ok, "El renderizado esta bien"}
  end

  def ejecutar(:purge_cache) do
    :timer.sleep(2900)
    {:ok, "El cache anda nitido"}
  end

  def ejecutar(:build_sitemap) do
    :timer.sleep(3333)
    {:ok, "Construccion hecha"}
  end

  def ejecutar(:logistic_control) do
    :timer.sleep(2390)
    {:ok, "El control de la logistica fue un exito"}
  end

  def ejercutar(:print_sheet) do
    :timer.sleep(1200) do
    {:ok, "las ojas se imprimeron con exito"}
    end
  end
end
