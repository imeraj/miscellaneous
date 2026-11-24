defmodule HelloSocketsWeb.DedupeChannel do
  use Phoenix.Channel

  intercept ["dedupe"]

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def broadcast(numbers, times) do
    Enum.each(1..times, fn _ ->
      Enum.each(numbers, fn number ->
        HelloSocketsWeb.Endpoint.broadcast!("dupe", "dedupe", %{number: number})
      end)
    end)
  end

  def handle_out("dedupe", %{number: number}, socket) do
    buffer = Map.get(socket.assigns, :buffer, [])
    next_buffer = [number | buffer]

    next_socket =
      socket
      |> assign(:buffer, next_buffer)
      |> enqueue_send_buffer()

    {:noreply, next_socket}
  end

  def handle_info(:send_buffer, %{assigns: %{buffer: buffer}} = socket) do
    buffer
    |> Enum.reverse()
    |> Enum.uniq()
    |> Enum.each(&push(socket, "number", %{value: &1}))

    new_socket =
      socket
      |> assign(:buffer, [])
      |> assign(:awaiting_buffer?, false)

    {:noreply, new_socket}
  end

  defp enqueue_send_buffer(%{assigns: %{awaiting_buffer?: true}} = socket), do: socket

  defp enqueue_send_buffer(socket) do
    Process.send_after(self(), :send_buffer, 1000)
    assign(socket, :awaiting_buffer?, true)
  end
end
