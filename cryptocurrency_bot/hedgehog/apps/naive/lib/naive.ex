defmodule Naive do
  @moduledoc """
  Documentation for `Naive`.
  """

  alias Naive.DynamicSymbolSupervisor

  def start_trading(symbol) do
    symbol
    |> String.upcase()
    |> DynamicSymbolSupervisor.start_worker()
  end

  def stop_trading(symbol) do
    symbol
    |> String.upcase()
    |> DynamicSymbolSupervisor.stop_worker()
  end

  defdelegate shutdown_trading(symbol), to: DynamicSymbolSupervisor
end
