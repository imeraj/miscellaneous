defmodule HelloSocketsWeb.RecurringChannel do
  use Phoenix.Channel

  @send_after 5000

  def join(_topic, _payload, socket) do
    schedule_send_token()
    {:ok, socket}
  end

  def handle_info(:send_token, socket) do
    push(socket, "new_token", %{token: new_token(socket)})
    schedule_send_token()
    {:noreply, socket}
  end

  defp schedule_send_token do
    Process.send_after(self(), :send_token, @send_after)
  end

  defp new_token(socket) do
    Phoenix.Token.sign(socket, "salt identifier", socket.assigns.user_id)
  end
end
