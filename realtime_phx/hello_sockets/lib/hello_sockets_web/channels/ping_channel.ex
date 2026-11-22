defmodule HelloSocketsWeb.PingChannel do
  use HelloSocketsWeb, :channel

  intercept ["request_ping"]

  @impl true
  def join("ping:" <> req_user_id, _payload, %{assigns: %{user_id: user_id}} = socket) do
    if req_user_id == to_string(user_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client

  @impl true
  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  @impl true
  def handle_in("pong", %{"error" => true}, socket) do
    {:reply, {:error, %{reasons: "You asked for this!"}}, socket}
  end

  @impl true
  def handle_in("pong", _payload, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_in("ding", _payload, socket) do
    {:stop, :shutdown, {:ok, %{msg: "shutting down"}}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (ping:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_out("request_ping", payload, socket) do
    push(socket, "send_ping", Map.put(payload, "from_node", Node.self()))
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(payload) when is_map(payload), do: true
  defp authorized?(_payload), do: false
end
