defmodule Notif do
  defstruct [:canal, :usuario, :plantilla]

  # Simula un envío de notificación según el canal usado
  def enviar(%Notif{canal: canal, usuario: user, plantilla: tpl}) do
    # Tiempo de envío según el canal
    delay =
      case canal do
        :push -> 1500   # 1.5s
        :email -> 2500  # 2.5s
        :sms -> 1800    # 1.8s
        _ -> 1000       # desconocido
      end

    :timer.sleep(delay)

    {:ok, "Enviada a #{user} (#{canal}) con plantilla #{tpl}"}
  end
end
