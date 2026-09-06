defmodule Naive.DynamicSymbolSupervisor do
  use DynamicSupervisor

  require Logger

  # API
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_trading(symbol) when is_binary(symbol) do
    Core.ServiceSupervisor.start_worker(
      String.upcase(symbol),
      Naive.Repo,
      Naive.Schema.Setting,
      __MODULE__,
      Naive.SymbolSupervisor
    )

    :ok
  end

  def stop_trading(symbol) when is_binary(symbol) do
    Core.ServiceSupervisor.stop_worker(
      String.upcase(symbol),
      Naive.Repo,
      Naive.Schema.Setting,
      __MODULE__,
      Naive.SymbolSupervisor
    )

    :ok
  end

  def autostart_trading do
    Core.ServiceSupervisor.autostart_workers(
      Naive.Repo,
      Naive.Schema.Setting,
      __MODULE__,
      Naive.SymbolSupervisor
    )
  end

  def shutdown_trading(symbol) when is_binary(symbol) do
    case Core.ServiceSupervisor.get_pid(Naive.SymbolSupervisor, symbol) do
      nil ->
        Logger.warning("#{Naive.SymbolSupervisor} worker for #{symbol} already stopped")

        {:ok, _settings} =
          Core.ServiceSupervisor.update_status(
            String.upcase(symbol),
            :off,
            Naive.Repo,
            Naive.Schema.Setting
          )

      _pid ->
        Logger.info("Initializing shutdown of #{Naive.SymbolSupervisor} worker for #{symbol}")

        # ^^^ updated

        {:ok, settings} =
          Core.ServiceSupervisor.update_status(
            String.upcase(symbol),
            :shutdown,
            Naive.Repo,
            Naive.Schema.Setting
          )

        Naive.Leader.notify(:settings_updated, settings)
    end

    :ok
  end

  ## Callbacks
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
