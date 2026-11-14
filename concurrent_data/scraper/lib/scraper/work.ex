defmodule Scrapper.Work do
  def do_something do
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end
end
