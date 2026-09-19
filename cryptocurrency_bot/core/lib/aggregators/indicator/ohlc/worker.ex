defmodule Aggregators.Indicator.Ohlc.Worker do
  use GenServer

  require Logger

  alias Struct.TradeEvent

  def start_link(symbol) do
    GenServer.start_link(__MODULE__, symbol)
  end

  # Callbacks
  def init(symbol) do
    symbol = String.upcase(symbol)

    Logger.info("Initializing a new OHLC worker for #{symbol}")

    Phoenix.PubSub.subscribe(
      Core.PubSub,
      "TRADE_EVENTS:#{symbol}"
    )

    {:ok, symbol}
  end

  def handle_info(%TradeEvent{} = trade_event, ohlc) do
    {:noreply, Aggregators.Indicator.Ohlc.process(ohlc, trade_event)}
  end
end
