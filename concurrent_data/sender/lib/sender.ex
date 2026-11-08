defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  def notify_all(emails) when is_list(emails) do
    Sender.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1,
      max_concurrency: 3,
      ordered: false
    )
    |> Enum.to_list()
  end

  def send_email("konnichiwa@world.com" = email),
    do: raise("Oops, coudn't send email to #{email}")

  def send_email(email) do
    Process.sleep(3000)
    IO.puts("Email to #{email} sent")
    {:ok, :email_sent}
  end
end
