#Punto 9 del taller de concurrencia
# Envio de Notificaciones

defmodule Notificacion do
  @moduledoc """
  CONTEXTO: tareas de mantenimiento: “reindex”, “purga caché”, “generar sitemap”.
  Modulo que crea una estructura "Notificación" que posee Canal, usuario, plantill
  """
  defstruct canal: "", usuario: "", plantilla: ""
end


defmodule EnvioNotificaciones do
  @moduledoc"""
  Contexto: enviar push/email/SMS (sin salir a la red; solo simula delay).
  Datos: %Notif{canal, usuario, plantilla}.
  Trabajo: enviar/1 = :timer.sleep(costo_por_canal).
  Secuencial vs Concurrente: por notificación.
  Salida: “Enviada a user X (canal Y)”; speedup.

  """

  def enviar_notificaciones(notificacion) do
    #Simulación del tiempo que toma el trabajo
    tiempo_envio = :timer.sleep(Enum.random(1..10))

    #Resultado en forma de tupla
    {notificacion.canal, notificacion.usuario, tiempo_envio}
  end
end

#Generador de notificaciones

defmodule GeneradorNotificaciones do
  @moduledoc"""
  Generacion de notificaciones de forma recursiva
  """

  #Crear la lista de notificaciones

  def crear_notificaciones(numero_notificaciones) do
    _crear(numero_notificaciones,1,1,[])
  end


  #Caso base (numero_notificaciones = 0)
  def _crear(0,_canal, _usuario, acc) do
    Enum.reverse(acc)
  end

  #Caso recursivo
  def _crear(numero_notificaciones, canal, usuario, acc)do
    mensajes_notificaciones = %Notificacion{canal: canal, usuario: usuario, plantilla: "Plantilla para user #{usuario}"}

    _crear(numero_notificaciones - 1, canal + 1, usuario + 1, [mensajes_notificaciones | acc])
  end
end

#-------------------------------------------------------------------------------
#Bloque de ejecucion

total_notificaciones = 50
IO.puts("El total de notificaciones generadas fueron #{total_notificaciones}")

notificaciones = GeneradorNotificaciones.crear_notificaciones(total_notificaciones)

#-------------------------------------------------------------------------------

  #EJECUCION DE FORMA SECUENCIAL

  IO.puts("Proceso secuencial")
  {tiempo_secuencial, resultados_sec} =
    :timer.tc(fn ->
      Enum.map(notificaciones, &EnvioNotificaciones.enviar_notificaciones/1)
    end)
  IO.puts("Procesamiento Secuencial Terminado")
  IO.puts("Tiempo: #{tiempo_secuencial / 1000} ms")

  IO.inspect(hd(resultados_sec), label: "Ejemplo de resultado para las primeras notificaciones")
#--------------------------------------------------------------------------------

  #EJECUCION DE FORMA CONCURRENTE/PARALELA
  IO.puts("Inicio de la ejecución concurrente/Paralela")
  {tiempo_concurrente, _resultado_con} =
    :timer.tc(fn ->
      notificaciones
      |> Enum.map(&Task.async(fn ->
  EnvioNotificaciones.enviar_notificaciones(&1) end))
      |> Task.await_many()
    end)
  IO.puts("Fin de la ejecució concurrente/paralela")
  IO.puts("Tiempo #{tiempo_concurrente / 1000} ms")

#----------------------------------------------------------------------------------

  #Calculo del SpeedUp

  IO.puts("Comparación del SpeedUP")
  if tiempo_concurrente > 0 do
    speedup = tiempo_secuencial/tiempo_concurrente
    IO.puts("La version concurrente fue #{Float.round(speedup, 2)} x mas rapida")
  else
    IO.puts("NO se puede calcular el SpeedUp")
  end

#---------------------------------------------------------------------------------

defmodule ServidorNotificaciones do
  @moduledoc """
  Este GenServer se encarga de recibir y procesar el envio de notificaciones
  de forma asincrona (sin esperar respuesta)
  """

  use GenServer

  #---Interfaz de cliente ---

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  ENvia una notificacion al servidor
  """
  def enviar(notificacion) do
    GenServer.cast(__MODULE__, {:enviar, notificacion})

  end

  #---LOgica del Servidor ---
  def init(state) do
    {:ok, state}
  end

  def handle_cast({:enviar, notificacion}, state) do
    :timer.sleep(Enum.random(1..10))

    IO.puts("[Servidor] Notificacion enviada al usuario")

    {:noreply, state}
  end
end
