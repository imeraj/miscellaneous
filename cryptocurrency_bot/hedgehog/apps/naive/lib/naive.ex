defmodule Naive do
  @moduledoc """
  Documentation for `Naive`.
  """

  alias Naive.DynamicSymbolSupervisor

  alias Streamer.DynamicStreamerSupervisor

  def start_trading(symbol) do
    symbol
    |> String.upcase()
    |> DynamicStreamerSupervisor.start_worker()
  end

  def stop_trading(symbol) do
    symbol
    |> String.upcase()
    |> DynamicStreamerSupervisor.stop_worker()
  end

  defdelegate shutdown_trading(symbol), to: DynamicSymbolSupervisor
end
