defmodule Streamer.DynamicStreamerSupervisor do
  use Core.ServiceSupervisor,
    repo: Streamer.Repo,
    schema: Streamer.Schema.Setting,
    module: __MODULE__,
    worker_module: Streamer.Binance

  def start_link(init_arg) do
    Core.ServiceSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  ## Callbacks
  def init(_init_arg) do
    Core.ServiceSupervisor.init(strategy: :one_for_one)
  end
end
