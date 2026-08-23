defmodule Streamer.Binance do
  use WebSockex

  require Logger

  alias Streamer.Binance.TradeEvent

  @stream_endpoint "wss://stream.binance.com:9443/ws/"

  def start_link(symbol) do
    symbol = String.downcase(symbol)
    url = "#{@stream_endpoint}#{symbol}@trade"

    WebSockex.start_link(url, __MODULE__, nil)
  end

  def handle_frame({_type, msg}, state) do
    case Jason.decode(msg) do
      {:ok, event} -> process_event(event)
      {:error, _} -> Logger.error("Unbable to parse msg: #{msg}")
    end

    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end

  defp process_event(%{"e" => "trade"} = event) do
    {trade_price, ""} = Float.parse(event["p"])

    trade_event = %TradeEvent{
      event_type: event["e"],
      event_time: event["E"],
      symbol: event["s"],
      trade_id: event["t"],
      price: trade_price,
      quantity: event["q"],
      trade_time: event["T"],
      buyer_market_maker: event["m"]
    }

    Logger.debug(
      "Trade event received " <>
        "#{trade_event.symbol}@#{trade_event.price}"
    )

    broadcast(trade_event)
  end

  defp broadcast(event) do
    Phoenix.PubSub.broadcast(Streamer.PubSub, "TRADE_EVENTS:#{event.symbol}", event)
  end
end
