defmodule Scraper.PageConsumer do
  use GenStage
  require Logger

  alias Scraper.PageProducer
  alias Scrapper.Work

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  # callbacks
  @impl GenStage
  def init(initial_state) do
    Logger.info("PageConsumer init")
    sub_opts = [{PageProducer, min_demand: 0, max_demand: 3}]
    {:consumer, initial_state, subscribe_to: sub_opts}
  end

  @impl GenStage
  def handle_events(events, _from, state) do
    Logger.info("PageConsumer received #{inspect(events)}")

    Enum.each(events, fn _page -> Work.do_something() end)

    {:noreply, [], state}
  end
end
