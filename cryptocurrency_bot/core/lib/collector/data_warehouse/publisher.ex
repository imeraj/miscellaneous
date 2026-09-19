defmodule DataWarehouse.Publisher do
  use Task

  import Ecto.Query, only: [from: 2]

  require Logger

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  # callbacks
  def run(%{
        type: :trade_events,
        symbol: symbol,
        from: from,
        to: to,
        interval: interval
      }) do
    symbol = String.upcase(symbol)

    from_ts = convert_to_ms("#{from}T00:00:00.000Z")
    to_ts = convert_to_ms("#{to}T23:59:59.000Z")

    Core.Repo.transact(
      fn ->
        from(te in Collector.DataWarehouse.Schema.TradeEvent,
          where:
            te.symbol == ^symbol and
              te.trade_time >= ^from_ts and te.trade_time <= ^to_ts,
          order_by: te.trade_time
        )
        |> Core.Repo.stream()
        |> Enum.with_index()
        |> Enum.map(fn {row, _index} ->
          :timer.sleep(interval)
          publish_trade_event(row)
        end)

        {:ok, :done}
      end,
      timeout: 10_000
    )

    Logger.info("Publisher finished streaming trade events")
  end

  defp publish_trade_event(%Collector.DataWarehouse.Schema.TradeEvent{} = trade_event) do
    new_trade_event =
      trade_event
      |> Map.from_struct()
      |> Map.update!(:price, &Decimal.to_float/1)
      |> Map.update!(:quantity, &Decimal.to_string/1)
      |> then(&struct(Struct.TradeEvent, &1))

    Phoenix.PubSub.broadcast(
      Core.PubSub,
      "TRADE_EVENTS:#{trade_event.symbol}",
      new_trade_event
    )
  end

  defp convert_to_ms(iso8601DateTimeString) do
    iso8601DateTimeString
    |> NaiveDateTime.from_iso8601!()
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.to_unix()
    |> Kernel.*(1000)
  end
end
