defmodule Naive.Trader.State do
  @moduledoc false

  @enforce_keys [:symbol, :profit_target, :tick_size, :buy_down_interval, :budget, :step_size]

  defstruct [
    :symbol,
    :buy_order,
    :sell_order,
    :profit_target,
    :tick_size,
    :buy_down_interval,
    :budget,
    :step_size
  ]
end
