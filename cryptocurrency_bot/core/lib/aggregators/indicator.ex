defmodule Aggregators.Indicator do
  def aggregate_ohlcs(symbol) do
    DynamicSupervisor.start_child(
      Aggregators.Indicator.DynamicSupervisor,
      {Aggregators.Indicator.Ohlc.Worker, symbol}
    )
  end
end
