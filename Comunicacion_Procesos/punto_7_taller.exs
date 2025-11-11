#Punto 7 del taller de paralelismo y concurrencia

defmodule Carrito do
  @moduledoc"""
  Definir la estructura del carrito de compras:
  - id: identificador del carrito
  - items: Una lista de precios de los productos del carrito
  . cupon: El cupón de descuento a aplicar(si lo hay)
  """
  defstruct id: nil, items: [], cupon: nil
end

defmodule ProcesadorDescuentos do
  @moduledoc """
  Pasos a seguir para el desarrollo de este punto del taller//
  a) Crear una estructura para (Que ira encima de este modulo para la creacion del carrito)
  b)La función o metodo que se implementara sera:
    Trabajo: total_con_descuentos/1 evalúa reglas + :timer.sleep(5..15)
  c)Aplicar el codigo a nivel secuencial y concurrente
  d)La salida final sera {id, total,_final}; Speedup
  NO OLVIDAR LA SIMULACION DE LA TAREA

  Este modulo se encarga de procesar los carritos para calcular el total final aplicando descuentos
  """

  @doc """
  Calcular el total final del carrito
  Esta funcion simula un trabajo pesado
  usa :timer.sleep/1

  """

  def total_con_descuentos(carrito) do
    #SIMULA QUE EL TRABAJO TOMA ENTRE 5 Y 15 milisegundos
     :timer.sleep(Enum.random(5..15))

     #logica del ejemplo: Suma los items y luego les aplica un 10% de descuento (para el ejemplo)
     total_final = Enum.sum(carrito.items) * 0.9

     #Devuelve la tupla con los resultados esperados
     {carrito.id, total_final}
  end
end

  #Preparación de los datos de prueba
defmodule GeneradorCarritos do
  @moduledoc"""
  Genera datos de prueba de forma recursiva
  """

  def crear_lista_carritos(n) do
    _crear(n,1,[])
  end

  #CASO BASE
  #Cuando n es 0
  def _crear(0,_id, acc) do
    Enum.reverse(acc)
  end

  #CASO RECURSIVO
  def _crear(n, id, acc) do
    nuevo_carrito = %Carrito{id: id, items: [10, 20, 30, 40 ,50, Enum.random(1..100)]}

    _crear(n - 1, id + 1, [nuevo_carrito | acc])
  end
end
#---------------------------------------------------------------------------------
  #Bloque de ejecucion

  total_carritos = 20
  IO.puts("Se generaron en total #{total_carritos} carritos de compra")

  carritos = GeneradorCarritos.crear_lista_carritos(total_carritos)
#--------------------------------------------------------------------------------

  #EJECUCION SECUENCIAL

  IO.puts("Inicio del proceso secuencial")
  {tiempo_secuencial, resultados_sec} =
    :timer.tc(fn ->
      Enum.map(carritos, &ProcesadorDescuentos.total_con_descuentos/1)
    end)
  IO.puts("Procesamiento Secuencial Terminado")
  IO.puts("Tiempo: #{tiempo_secuencial / 1000} ms")

  IO.inspect(hd(resultados_sec), label: "Ejemplo de resultado para el primer carrito")

#------------------------------------------------------------------------------
  #EJECUCION CONCURRENTE/PARALELA
  IO.puts("Inicio de la ejecución Concurrente/Paralela")
  {tiempo_concurrente, _resultados_con} =
    :timer.tc(fn ->
      carritos
      |> Enum.map(&Task.async(fn ->
  ProcesadorDescuentos.total_con_descuentos(&1) end))
      |>Task.await_many()
    end)

  IO.puts("Fin de la ejecucion Concurrente/Paralela")
  IO.puts("Tiempo: #{tiempo_concurrente / 1000} ms")

#--------------------------------------------------------------------------------

#Calculo del SpeedUp

  IO.puts("Comparacion del SpeedUP")
  if tiempo_concurrente > 0 do
    speedup = tiempo_secuencial/tiempo_concurrente
    IO.puts("La version concurrente fue #{Float.round(speedup, 2)} x mas rapida")
  else
    IO.puts("No se puede calcular el speedup")
  end

#------------------------------------------------------------------------------

defmodule ServidorDescuentos do
  @moduledoc """
  Un GenServer que procesa descuentos para carritos de forma centralizada.
  """
  use GenServer

  #--- Interfaz de Cliente ---

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Envia una solicitud
  """

  def calcular(carrito) do
    GenServer.call(__MODULE__, {:calcular, carrito})
  end

  #-- Logica del Servidor ---

  def init(state) do
    {:ok, state}
  end

  def handle_call({:calcular, carrito}, _from, state) do
    :timer.sleep(Enum.random(5..15))
    total_final = Enum.sum(carrito.items) * 0.9
    resultado = {carrito.id, total_final}

    {:reply, resultado, state}
  end
end
