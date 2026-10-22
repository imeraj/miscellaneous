defmodule Fresco.UserManager do
  @moduledoc """
  The UserManager context.
  """

  import Ecto.Query, warn: false
  alias Fresco.Repo

  alias Fresco.UserManager.User

  def authenticate_user(tenant, username, given_password) do
    query = Ecto.Query.from(u in User, where: u.username == ^username)

    Repo.one(query, prefix: Triplex.to_prefix(tenant))
    |> check_password(given_password)
  end

  defp check_password(nil, _) do
    Argon2.no_user_verify()
    {:error, :invalid_credentials}
  end

  defp check_password(user, given_password) do
    case Argon2.verify_pass(given_password, user.password) do
      true -> {:ok, user}
      false -> {:error, :invalid_credentials}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(tenant, id), do: Repo.get!(User, id, prefix: Triplex.to_prefix(tenant))

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(tenant, attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
