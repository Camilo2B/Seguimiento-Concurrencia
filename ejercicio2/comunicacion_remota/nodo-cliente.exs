defmodule NodoCliente do

  @nodo_cliente :"cliente@192.168.137.239"
  @nodo_servidor :"servidor@192.168.137.239"
  @nombre_proceso :servicio_cadenas

 @mensajes
    [
  %Producto{nombre: "Camisa Blanca", stock: 18, precio_sin_iva: 150000, iva: 0.19},
  %Producto{nombre: "Pantalones Vaqueros", stock: 25, precio_sin_iva: 200000, iva: 0.16},
  %Producto{nombre: "Chaqueta de Cuero", stock: 10, precio_sin_iva: 450000, iva: 0.20},
  %Producto{nombre: "Sombrero de Lana", stock: 30, precio_sin_iva: 80000, iva: 0.10},
  %Producto{nombre: "Bufanda Roja", stock: 15, precio_sin_iva: 50000, iva: 0.12},
  %Producto{nombre: "Guantes de Invierno", stock: 20, precio_sin_iva: 60000, iva: 0.15},
  %Producto{nombre: "Bolso de Mano", stock: 12, precio_sin_iva: 300000, iva: 0.18},
  %Producto{nombre: "Reloj Analógico", stock: 8, precio_sin_iva: 250000, iva: 0.22},
  %Producto{nombre: "Pulsera de Plata", stock: 22, precio_sin_iva: 100000, iva: 0.14},
  %Producto{nombre: "Collar de Perlas", stock: 16, precio_sin_iva: 180000, iva: 0.17},
  %Producto{nombre: "Aretes Dorados", stock: 19, precio_sin_iva: 70000, iva: 0.13},
  %Producto{nombre: "Botas de Montaña", stock: 14, precio_sin_iva: 350000, iva: 0.21},
  %Producto{nombre: "Sandalias de Playa", stock: 28, precio_sin_iva: 90000, iva: 0.11},
  %Producto{nombre: "Gorra Deportiva", stock: 26, precio_sin_iva: 40000, iva: 0.09},
  %Producto{nombre: "Cinturón de Cuero", stock: 17, precio_sin_iva: 120000, iva: 0.19},
  %Producto{nombre: "Mochila Escolar", stock: 21, precio_sin_iva: 220000, iva: 0.16},
  %Producto{nombre: "Lentes de Lectura", stock: 13, precio_sin_iva: 60000, iva: 0.15},
  %Producto{nombre: "Bufanda de Seda", stock: 11, precio_sin_iva: 140000, iva: 0.20},
  %Producto{nombre: "Chaleco Deportivo", stock: 24, precio_sin_iva: 160000, iva: 0.18},
  %Producto{nombre: "Calcetines de Algodón", stock: 32, precio_sin_iva: 20000, iva: 0.10}
    ]

  def main() do
    IO.puts("SE INICIA EL CLIENTE")
    iniciar_nodo(@nodo_cliente)
    establecer_conexion(@nodo_servidor)
    |> iniciar_produccion()
  end

  defp iniciar_nodo(nombre) do
    Node.start(nombre)
    Node.set_cookie(:my_cookie)
  end

  defp establecer_conexion(nodo_remoto) do
    Node.connect(nodo_remoto)
  end

  defp iniciar_produccion(false), do: IO.puts("No se pudo conectar con el nodo servidor")

  defp iniciar_produccion(true) do
    enviar_mensajes()
    recibir_respuestas()
  end

  defp enviar_mensajes() do
    Enum.each(@mensajes, &enviar_mensaje/1)
  end

  defp enviar_mensaje(mensaje) do
    send({@nombre_proceso, @nodo_servidor}, {self(), mensaje})
  end

  defp recibir_respuestas() do
    receive do
      :fin -> :ok
      respuesta ->
        IO.puts("\t -> \"#{respuesta}\"")
        recibir_respuestas()
    end
  end
end

NodoCliente.main()
