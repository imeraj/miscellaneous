defmodule FrescoWeb.Subdomain.SessionController do
  use FrescoWeb, :controller

  alias Fresco.UserManager
  alias Fresco.UserManager.User
  alias Fresco.UserManager.Guardian

  def new(conn, _params) do
    changeset = UserManager.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: ~p"/products")
    else
      render(conn, :new, changeset: changeset)
    end
  end

  def create(conn, %{
        "session" => %{
          "username" => username,
          "password" => password
        }
      }) do
    UserManager.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "Please enter your username and password.")
    |> redirect(to: ~p"/login")
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: ~p"/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: ~p"/products")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> redirect(to: ~p"/login")
  end
end
