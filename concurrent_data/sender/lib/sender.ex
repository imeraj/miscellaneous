defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  def notify_all(emails) when is_list(emails) do
    emails
    |> Task.async_stream(&send_email/1,
      max_concurrency: 3,
      ordered: false,
      on_timeout: :kill_task
    )
    |> Enum.to_list()
  end

  def send_email(email) do
    Process.sleep(Enum.random([3000, 4000, 5000, 10000]))

    IO.puts("Email to #{email} sent")
    {:ok, :email_sent}
  end
end
