# Punto 10 del taller de concurrencia
# Preparació de paquetes (logística)

defmodule Paquete do
  @moduledoc """
  Estructura para el paquete
  """

  defstruct id: nil, peso: 0, fragil: true

end

defmodule PreparacionPaquetes do
  @moduledoc """
  Contexto: empacar pedidos con pasos: etiquetar, pesar, embalar.
  Datos: %Paquete{id, peso, fragil?}.
  Trabajo: preparar/1 hace 2–3 sleeps según flags.
  Secuencial vs Concurrente: por paquete.
  Salida: {id, listo_en_ms}; speedup.
  """

  def empacar_paquetes(paquetes) do
    #Simulacion de empaquetado
    proceso_de_empaquetado = :timer.sleep(Enum.random(1..10))

    #Resultado en forma de tupla
    {paquetes.id, paquetes.peso, paquetes.fragil, proceso_de_empaquetado}
  end
end

#Generador de notificaciones

defmodule GenerarPaqueteria do
  @moduledoc """
  Generacion de paqueteria de forma recursiva
  """

  #Crear lista de paquetes

  def crear_paquetes(numero_paquetes) do
    _crear(numero_paquetes,1,1,[])
  end

  #Caso base (numero_paquetes = 0)
  def _crear(0, _id, _peso, acc) do
    Enum.reverse(acc)
  end

  #Caso recursivo
  def _crear(numero_paquetes, id, peso, acc)do
    creacion_paquetes = %Paquete{id: id, peso: peso, fragil: true}
    _crear(numero_paquetes - 1, id + 1, peso + 1, [creacion_paquetes | acc])
  end
end

#--------------------------------------------------------------------------------

  #BLOQUE DE EJECUCIÓN

  total_paquetes = 100
  IO.puts("El total de paquetes que fueron empacados #{total_paquetes}")

  paquetes = GenerarPaqueteria.crear_paquetes(total_paquetes)

#---------------------------------------------------------------------------------

  #EJECUCION DE FORMA SECUENCIAL
  IO.puts("Proceso Secuencial")
  {tiempo_secuencial, resultados_sec} =
    :timer.tc(fn ->
      Enum.map(paquetes, &PreparacionPaquetes.empacar_paquetes/1)
    end)
  IO.puts("Procesamiento Secuencial Terminado")
  IO.puts("Tiempo: #{tiempo_secuencial / 1000} ms")

  IO.inspect(hd(resultados_sec), label: "Ejemplo de resultado para las primeros paquetes" )
#----------------------------------------------------------------------------------

  #EJECUCION DE FORMA CONCURRENTE/PARALELA
  IO.puts("Inicio de la ejecución concurrente/Paralela")
  {tiempo_concurrente, _resultado_con} =
    :timer.tc(fn ->
      paquetes
      |> Enum.map(&Task.async(fn ->
  PreparacionPaquetes.empacar_paquetes(&1) end))
      |> Task.await_many()
    end)

  IO.puts("Fin de la ejecució concurrente/paralela")
  IO.puts("Tiempo #{tiempo_concurrente / 1000} ms")

#------------------------------------------------------------------------------------

  #Calculo del SpeedUP
  IO.puts("Comparacion del SpeedUP")
  if tiempo_concurrente > 0 do
    speedup = tiempo_secuencial/tiempo_concurrente
    IO.puts("La version concurrente fue #{Float.round(speedup, 2)} x mas rapida")
  else
    IO.puts("NO se puede calcular el SpeedUP")
  end


#------------------------------------------------------------------------------------

defmodule ServidorPaquetes do
  use GenServer

  # --- Interfaz de Cliente ---
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def procesar(paquete) do
    GenServer.call(__MODULE__, {:procesar, paquete})
  end

  # --- Servidor ---

  def init(state) do
    {:ok, state}
  end

  def handle_call({:procesar, paquete}, _from, state) do
    :timer.sleep(Enum.random(1..10))
    resultado = {paquete.id, paquete.peso, paquete.fragil, :procesado}

    {:reply, resultado, state}
  end

end
