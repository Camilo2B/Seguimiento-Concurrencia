# Punto 11 del taller de concurrencia
# Preparació de paquetes (logística)

defmodule Comentario do
  @moduledoc """
  Estructura del comentario
  """
  defstruct id: nil, texto: ""
end


defmodule ModeracionComentarios do
  @moduledoc """
  Contexto: reglas simples (palabras prohibidas, longitud, links).
  Datos: %Comentario{id, texto}.
  Trabajo: moderar/1 recorre reglas + :timer.sleep(5..12).
  Secuencial vs Concurrente: por comentario.
  Salida: {id, :aprobado | :rechazado}; speedup.
  """

  def moderar_comentarios(comentario) do
    #Simulación de proceso
    proceso_moderación = :timer.sleep(Enum.random(5..12))

    #Resultado en forma de tupla
    {comentario.id, :aprobado}
  end
end

#Generador de comentarios

defmodule GenerarComentarios do
  @moduledoc"""
  Generar comentarios de forma recursiva
  """
  #Crear lista de comentarios

  def crear_comentarios(numero_comentarios) do
    _crear(numero_comentarios, 1, [])
  end

  #Caso base (numero_comentarios = 0)
  def _crear(0, _id, acc) do
    Enum.reverse(acc)
  end

  #Caso recursivo
  def _crear(numero_comentarios, id, acc) do
    crear_comentarios = %Comentario{id: id, texto: "Este es el comentario #{id}"}
    _crear(numero_comentarios - 1, id + 1, [crear_comentarios | acc])
  end
end

#-----------------------------------------------------------------------------

 #BLOQUE DE EJECUCION

 total_comentarios = 100
 IO.puts("Total de comentarios generados #{total_comentarios}")

 comentarios = GenerarComentarios.crear_comentarios(total_comentarios)

#------------------------------------------------------------------------------

  #EJECUCION SECUENCIAL
  IO.puts("Proceso Secuencial")
  {tiempo_secuencial, resultados_sec} =
    :timer.tc(fn ->
      Enum.map(comentarios, &ModeracionComentarios.moderar_comentarios/1)
    end)
  IO.puts("Procesamiento Secuencial Terminado")
  IO.puts("Tiempo: #{tiempo_secuencial / 1000} ms")

  IO.inspect(hd(resultados_sec), label: "Ejemplo de resultado para los primeros comentarios")

#---------------------------------------------------------------------------------

  #EJECUCION DE FORMA PARALELA/CONCURRENTE
  IO.puts("Proceso Concurrente/Paralelo")
  {tiempo_concurrente, _resultados_sec} =
    :timer.tc(fn ->
      comentarios
      |> Enum.map(&Task.async(fn ->
  ModeracionComentarios.moderar_comentarios(&1) end))
      |> Task.await_many()
    end)

  IO.puts("Fin de la ejecució concurrente/paralela")
  IO.puts("Tiempo #{tiempo_concurrente / 1000} ms")

#-----------------------------------------------------------------------------------

  #Calculo del SpeddUP
  IO.puts("Calculo del SpeedUP")
  if tiempo_concurrente > 0 do
    speedup = tiempo_secuencial/tiempo_concurrente
    IO.puts("La version concurrente fue #{Float.round(speedup, 2)} x mas rapida")
  else
    IO.puts("No se pudo calcular el Speedup")
  end
