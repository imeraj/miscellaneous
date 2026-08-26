defmodule Naive.Trader.State do
  @moduledoc false

  @enforce_keys [
    :id,
    :symbol,
    :profit_target,
    :tick_size,
    :buy_down_interval,
    :budget,
    :step_size,
    :rebuy_notified,
    :rebuy_interval
  ]

  defstruct [
    :id,
    :symbol,
    :buy_order,
    :sell_order,
    :profit_target,
    :tick_size,
    :buy_down_interval,
    :budget,
    :step_size,
    :rebuy_interval,
    :rebuy_notified
  ]
end
