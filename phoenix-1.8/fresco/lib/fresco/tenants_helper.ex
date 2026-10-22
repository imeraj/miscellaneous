defmodule Fresco.TenantsHelper do
  alias Fresco.Accounts
  alias Fresco.Repo

  def create_tenant(name, brand_colour) do
    # 1. Create the database schema and run migrations first
    case Triplex.create_schema(name, Repo, fn tenant, repo -> Triplex.migrate(tenant, repo) end) do
      {:ok, _} ->
        # 2. Write your tenant record and explicitly return the tuple format required by transact
        Repo.transact(fn ->
          case Accounts.create_account(%{name: name, brand_colour: brand_colour}) do
            {:ok, account} -> {:ok, account}
            {:error, changeset} -> Repo.rollback(changeset)
          end
        end)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
