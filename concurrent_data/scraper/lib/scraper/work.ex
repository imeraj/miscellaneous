defmodule Scraper.Work do
  def do_something do
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end

  def online?(_url) do
    do_something()

    Enum.random([false, true, true])
  end
end
