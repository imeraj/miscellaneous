defmodule Fresco.UserManager.Guardian do
  use Guardian, otp_app: :fresco

  alias Fresco.UserManager

  @impl Guardian
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  @impl Guardian
  def build_claims(claims, _user, opts) do
    tenant = Keyword.fetch!(opts, :tenant)

    claims =
      claims
      |> Map.put("tenant", to_string(tenant))

    {:ok, claims}
  end

  @impl Guardian
  def resource_from_claims(%{"sub" => id, "tenant" => tenant}) do
    user = UserManager.get_user!(tenant, id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_claims}
  end
end
