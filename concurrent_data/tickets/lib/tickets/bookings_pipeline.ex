defmodule Tickets.BookingsPipeline do
  use Broadway

  alias Tickets.Ticket
  alias Tickets.BookingsPipeline

  @producer BroadwayRabbitMQ.Producer

  @producer_config [
    queue: "bookings_queue",
    declare: [durable: true],
    on_failure: :reject_and_requeue
  ]

  def start_link(_args) do
    options = [
      name: BookingsPipeline,
      producer: [module: {@producer, @producer_config}],
      processors: [
        default: [
          concurrency: System.schedulers_online() * 2
        ]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  @impl Broadway
  def prepare_messages(messages, _context) do
    messages =
      Enum.map(messages, fn message ->
        Broadway.Message.update_data(message, fn data ->
          [event, user_id] = String.split(data, ",")
          %{event: event, user_id: user_id}
        end)
      end)

    users = Ticket.users_by_ids(Enum.map(messages, & &1.data.user_id))

    Enum.map(messages, fn message ->
      Broadway.Message.update_data(message, fn data ->
        user = Enum.find(users, &(&1.id == data.user_id))
        Map.put(data, :user, user)
      end)
    end)
  end

  @impl Broadway
  def handle_message(_processor, message, _context) do
    %{data: %{event: event, user: user}} = message

    if Ticket.tickets_available?(event) do
      Ticket.create_ticket(user, event)
      Ticket.send_email(user)
      IO.inspect(message, label: "Message")
    else
      Broadway.Message.failed(message, "bookings-closed")
    end
  end

  @impl Broadway
  def handle_failed(messages, _context) do
    IO.inspect(messages, label: "Failed messages")

    Enum.map(messages, fn
      %{status: {:failed, "bookings-closed"}} = message ->
        Broadway.Message.configure_ack(message, on_failure: :reject)

      message ->
        message
    end)
  end
end
