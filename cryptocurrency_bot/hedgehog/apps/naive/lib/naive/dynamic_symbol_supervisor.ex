defmodule Naive.DynamicSymbolSupervisor do
  use Core.ServiceSupervisor,
    repo: Naive.Repo,
    schema: Naive.Schema.Setting,
    worker_module: Naive.SymbolSupervisor,
    module: __MODULE__

  require Logger

  # API
  def start_link(init_arg) do
    Core.ServiceSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_trading(symbol) do
    symbol
    |> String.upcase()
    |> __MODULE__.start_worker()
  end

  def stop_trading(symbol) do
    symbol
    |> String.upcase()
    |> __MODULE__.stop_worker()
  end

  def shutdown_trading(symbol) when is_binary(symbol) do
    case get_pid(symbol) do
      nil ->
        Logger.warning("#{Naive.SymbolSupervisor} worker for #{symbol} already stopped")

        {:ok, _settings} =
          update_status(
            String.upcase(symbol),
            :off
          )

      _pid ->
        Logger.info("Initializing shutdown of #{Naive.SymbolSupervisor} worker for #{symbol}")

        # ^^^ updated

        {:ok, settings} =
          update_status(
            String.upcase(symbol),
            :shutdown
          )

        Naive.Leader.notify(:settings_updated, settings)
    end

    :ok
  end

  ## Callbacks
  def init(_init_arg) do
    Core.ServiceSupervisor.init(strategy: :one_for_one)
  end
end
