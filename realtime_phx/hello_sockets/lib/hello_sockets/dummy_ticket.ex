defmodule HelloSockets.DummyTicket do
  @moduledoc """
  A dummy ticket artifact mirroring Linear issue REX-5.
  """

  def info do
    %{
      identifier: "REX-5",
      title: "Test issue",
      description: "create a dummy ticket"
    }
  end
end
