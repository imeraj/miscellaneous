defmodule Scraper.PageConsumer do
  require Logger

  def start_link(event) do
    Logger.info("PageConsumer received #{event}")

    Task.start_link(fn ->
      Scraper.Work.do_something()
    end)
  end
end
