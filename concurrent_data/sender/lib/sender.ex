defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  def notify_all(emails) when is_list(emails) do
    emails
    |> Enum.map(fn email -> Task.async(fn -> send_email(email) end) end)
    |> Task.await_many()
  end

  def send_email(email) do
    Process.sleep(3000)
    IO.puts("Email to #{email} sent")
    {:ok, :email_sent}
  end
end
