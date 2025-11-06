defmodule Procesador do
  def procesar_secuencial(lista_usuarios) do
    Enum.map(lista_usuarios, &UserValidator.validar/1)
    #Enum.map(lista_usuarios, fn usuario -> UserValidator.validar(usuario) end)
  end

  def procesar_concurrente(lista_usuarios) do
    lista_usuarios
    |> Task.async_stream(&UserValidator.validar/1,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.map(fn {:ok, resultado} -> resultado end)
  end
end
