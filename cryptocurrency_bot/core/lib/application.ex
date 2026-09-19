defmodule Core.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Core.Repo,
      {
        Phoenix.PubSub,
        name: Core.PubSub
      },
      Exchange.BinanceMock,
      Streamer.Binance.Supervisor,
      {Strategy.Naive.Supervisor, []},
      {Collector.DataWarehouse.CollectorSupervisor, []},
      {DynamicSupervisor, strategy: :one_for_one, name: Aggregators.Indicator.DynamicSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Core.Application]
    Supervisor.start_link(children, opts)
  end
end
