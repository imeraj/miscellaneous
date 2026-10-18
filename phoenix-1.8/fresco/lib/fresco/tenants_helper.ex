defmodule Fresco.TenantsHelper do
  alias Fresco.Accounts
  alias Fresco.Repo

  def create_tenant(name, brand_colour) do
    Repo.transact(fn ->
      Triplex.create_schema(name, Repo, fn tenant, repo ->
        {:ok, _} = Triplex.migrate(tenant, repo)
      end)

      {:ok, _account} = Accounts.create_account(%{name: name, brand_colour: brand_colour})
    end)
  end
end
