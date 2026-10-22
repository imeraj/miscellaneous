defmodule FrescoWeb.Subdomain.UserController do
  use FrescoWeb, :controller

  alias Fresco.UserManager
  alias Fresco.UserManager.User

  import Fresco.UserManager.Auth, only: [load_current_user: 2]

  plug(:load_current_user when action in [:show])

  def new(conn, _params) do
    changeset = UserManager.change_user(%User{})

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case UserManager.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully. Please log in.")
        |> redirect(to: ~p"/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
