send_messages = fn num_messages ->
  {:ok, connection} = AMQP.Connection.open()
  {:ok, channel} = AMQP.Channel.open(connection)

  # Same name and options as Tickets.BookingsPipeline
  AMQP.Queue.declare(channel, "bookings_queue", durable: true)

  Enum.each(1..num_messages//1, fn _ ->
    event = Enum.random(["cinema", "musical", "play"])
    user_id = Enum.random(1..3)

    AMQP.Basic.publish(
      channel,
      "",
      "bookings_queue",
      "#{event},#{user_id}",
      persistent: true
    )
  end)

  AMQP.Channel.close(channel)
  AMQP.Connection.close(connection)
end
