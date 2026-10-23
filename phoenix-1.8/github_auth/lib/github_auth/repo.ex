defmodule GithubAuth.Repo do
  use Ecto.Repo,
    otp_app: :github_auth,
    adapter: Ecto.Adapters.Postgres
end
