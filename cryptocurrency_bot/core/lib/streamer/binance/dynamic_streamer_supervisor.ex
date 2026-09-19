defmodule Streamer.Binance.DynamicStreamerSupervisor do
  use Core.ServiceSupervisor,
    repo: Core.Repo,
    schema: Streamer.Binance.Schema.Setting,
    module: __MODULE__,
    worker_module: Streamer.Binance.Worker

  def start_link(init_arg) do
    Core.ServiceSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  ## Callbacks
  def init(_init_arg) do
    Core.ServiceSupervisor.init(strategy: :one_for_one)
  end
end
