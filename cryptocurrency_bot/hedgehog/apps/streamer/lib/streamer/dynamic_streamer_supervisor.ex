defmodule Streamer.DynamicStreamerSupervisor do
  use DynamicSupervisor

  import Ecto.Query

  require Logger

  alias Streamer.Repo
  alias Streamer.Schema.Setting

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def autostart_streaming do
    Enum.map(fetch_symbols_to_stream(), &start_streaming/1)
  end

  def start_streaming(symbol) when is_binary(symbol) do
    case get_pid(symbol) do
      nil ->
        Logger.info("Starting streaming on #{symbol}")
        {:ok, _settings} = update_streaming_status(symbol, :on)
        {:ok, _pid} = start_streamer(symbol)

      pid ->
        Logger.warning("Streaming on #{symbol} already started")
        {:ok, _settings} = update_streaming_status(symbol, :on)
        {:ok, pid}
    end
  end

  def stop_streaming(symbol) when is_binary(symbol) do
    case get_pid(symbol) do
      nil ->
        Logger.warning("Streaming on #{symbol} already stopped")
        {:ok, _settings} = update_streaming_status(symbol, :off)

      pid ->
        Logger.info("Stopping streaming on #{symbol}")

        :ok =
          DynamicSupervisor.terminate_child(
            Streamer.DynamicStreamerSupervisor,
            pid
          )

        {:ok, _settings} = update_streaming_status(symbol, :off)
    end

    :ok
  end

  ## callbacks
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # private functions
  defp get_pid(symbol) do
    Process.whereis(:"Elixir.Streamer.Binance-#{String.upcase(symbol)}")
  end

  defp update_streaming_status(symbol, status)
       when is_binary(symbol) and is_atom(status) do
    Repo.get_by(Setting, symbol: String.upcase(symbol))
    |> Ecto.Changeset.change(%{status: status})
    |> Repo.update()
  end

  defp fetch_symbols_to_stream do
    Repo.all(
      from(s in Setting,
        where: s.status == :on,
        select: s.symbol
      )
    )
  end

  defp start_streamer(symbol) do
    DynamicSupervisor.start_child(
      Streamer.DynamicStreamerSupervisor,
      {Streamer.Binance, symbol}
    )
  end
end
