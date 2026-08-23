defmodule Naive.Trader do
  @moduledoc false

  use GenServer, restart: :temporary

  require Logger

  alias Naive.Trader.State
  alias Streamer.Binance.TradeEvent
  alias Decimal, as: D

  @binance_client Application.compile_env(:naive, :binance_client)

  ## Client APIs
  def start_link(%State{} = state) do
    GenServer.start_link(__MODULE__, state)
  end

  ## Callbacks
  @impl GenServer
  def init(state) do
    symbol = String.upcase(state.symbol)

    Logger.info("Initializing new trader for #{symbol}")

    subscribe(symbol)

    {:ok, state}
  end

  @impl GenServer
  def handle_info(%TradeEvent{} = trade_event, %{buy_order: nil} = state) do
    %{price: price} = trade_event
    symbol = state.symbol
    price = calculate_buy_price(price, state.buy_down_interval, state.tick_size)
    quantity = "100"

    Logger.info("Placing BUY order for #{symbol} @ #{price}, quantity: #{quantity}")

    {:ok, %Binance.OrderResponse{} = order} =
      @binance_client.order_limit_buy(symbol, quantity, price, "GTC")

    new_state = %{state | buy_order: order}
    #  Naive.Leader.notify(new_state)

    {:noreply, new_state}
  end

  def handle_info(
        %TradeEvent{
          price: trade_price
        },
        %State{
          symbol: symbol,
          buy_order: %Binance.OrderResponse{
            price: buy_price,
            order_id: order_id,
            orig_qty: quantity,
            transact_time: timestamp
          },
          sell_order: nil,
          profit_target: profit_target,
          tick_size: tick_size
        } = state
      )
      when trade_price <= buy_price do
    {:ok, %Binance.Order{} = current_buy_order} =
      @binance_client.get_order(
        symbol,
        timestamp,
        order_id
      )

    buy_order_response = convert_order_to_order_response(current_buy_order)

    sell_price = calculate_sell_price(buy_price, profit_target, tick_size)

    Logger.info(
      "Buy order filled, placing SELL order for " <>
        "#{symbol} @ #{sell_price}, quantity: #{quantity}"
    )

    {:ok, %Binance.OrderResponse{} = order} =
      @binance_client.order_limit_sell(symbol, quantity, sell_price, "GTC")

    new_state = %{state | buy_order: buy_order_response, sell_order: order}
    Naive.Leader.notify(new_state)

    {:noreply, new_state}
  end

  def handle_info(
        %TradeEvent{},
        %State{
          symbol: symbol,
          sell_order: %Binance.OrderResponse{
            price: _sell_price,
            order_id: order_id,
            transact_time: timestamp
          }
        } = state
      ) do
    {:ok, %Binance.Order{} = current_sell_order} =
      @binance_client.get_order(
        symbol,
        timestamp,
        order_id
      )

    if current_sell_order.status == "FILLED" do
      sell_order_response = convert_order_to_order_response(current_sell_order)

      Logger.info("Trade finished, trader will now exit")

      new_state = %{state | sell_order: sell_order_response}
      Naive.Leader.notify(new_state)

      {:stop, :normal, new_state}
    else
      {:noreply, state}
    end
  end

  def handle_info(%TradeEvent{}, state) do
    {:noreply, state}
  end

  ## Private functions
  defp subscribe(symbol) do
    Phoenix.PubSub.subscribe(Streamer.PubSub, "TRADE_EVENTS:#{symbol}")
  end

  defp convert_order_to_order_response(%Binance.Order{} = order) do
    response = struct(Binance.OrderResponse, Map.from_struct(order))
    %{response | transact_time: order.time}
  end

  defp calculate_buy_price(current_price, buy_down_interval, tick_size) do
    current_price = D.from_float(current_price)
    exact_buy_price = D.sub(current_price, D.mult(current_price, buy_down_interval))

    exact_buy_price
    |> D.div(tick_size)
    |> D.mult(tick_size)
    |> D.to_float()
  end

  defp calculate_sell_price(buy_price, profit_target, tick_size) do
    fee = D.new("1.001")

    buy_price
    |> D.from_float()
    |> D.mult(fee)
    |> D.mult(D.add(D.new(1), profit_target))
    |> D.mult(fee)
    |> D.div(tick_size)
    |> D.mult(tick_size)
    |> D.to_float()
  end
end
