defmodule Core.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        Phoenix.PubSub,
        name: Core.PubSub
      }
    ]

    opts = [strategy: :one_for_one, name: Core.Application]
    Supervisor.start_link(children, opts)
  end
end
