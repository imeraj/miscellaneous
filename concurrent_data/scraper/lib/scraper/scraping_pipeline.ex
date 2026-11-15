defmodule Scraper.ScrapingPipeline do
  use Broadway
  require Logger

  def start_link(_args) do
    options = [
      name: ScrapingPipeline,
      producer: [
        module: {Scraper.PageProducer, []},
        transformer: {__MODULE__, :transform, []}
      ],
      processors: [
        default: [max_demand: 1, concurrency: 2]
      ],
      batchers: [
        default: [batch_size: 1, concurrency: 2]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  @impl Broadway
  def handle_message(_processor, message, _context) do
    if Scraper.Work.online?(message.data),
      do: Broadway.Message.put_batch_key(message, message.data),
      else: Broadway.Message.failed(message, "failed")
  end

  @impl Broadway
  def handle_batch(_batcher, [message], _batch_info, _context) do
    Logger.info("Batch Processor received #{message.data}")
    Scraper.Work.do_something()
    [message]
  end

  @impl Broadway
  def handle_failed([message], _context) do
    IO.inspect(message, label: "Failed messages")
    [message]
  end

  def transform(event, _options) do
    %Broadway.Message{
      data: event,
      acknowledger: {Scraper.ScrapingPipeline, :pages, []}
    }
  end

  def ack(:pages, _successful, _failed), do: :ok
end
