defmodule Scraper.PageConsumer do
  @moduledoc """
  This is unused for using broadway instead
  """
  require Logger

  def start_link(event) do
    Logger.info("PageConsumer received #{event}")

    Task.start_link(fn ->
      Scraper.Work.do_something()
    end)
  end
end
