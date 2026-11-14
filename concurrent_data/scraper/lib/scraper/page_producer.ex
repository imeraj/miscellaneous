defmodule Scraper.PageProducer do
  use GenStage
  require Logger

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def scrape_pages(pages) do
    GenServer.cast(__MODULE__, {:pages, pages})
  end

  # callbacks
  @impl GenStage
  def init(initial_state) do
    Logger.info("PageProducer init")

    partitions = [:a, :b]

    hash = fn event ->
      {event, Enum.at(partitions, :erlang.phash2(event, length(partitions)))}
    end

    opts = [
      partitions: partitions,
      hash: hash
    ]

    {:producer, initial_state, dispatcher: {GenStage.PartitionDispatcher, opts}}
  end

  @impl GenStage
  def handle_cast({:pages, pages}, state) do
    {:noreply, pages, state}
  end

  @impl GenStage
  def handle_demand(demand, state) do
    Logger.info("PageProducer received demand for #{demand} pages")

    events = []
    {:noreply, events, state}
  end
end
