defmodule HelloSockets.DummyTicketTest do
  use ExUnit.Case, async: true

  test "info/0 returns the REX-5 ticket details" do
    assert HelloSockets.DummyTicket.info() == %{
             identifier: "REX-5",
             title: "Test issue",
             description: "create a dummy ticket"
           }
  end
end
