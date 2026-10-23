defmodule GithubAuthWeb.AuthController do
  use GithubAuthWeb, :controller

  alias Ueberauth.Auth
  alias GithubAuth.Accounts

  def login(%{assigns: %{current_user: current_user}} = conn, _params) do
    if current_user,
      do: redirect(conn, to: ~p"/"),
      else: render(conn, :login)
  end

  def request(conn, _params), do: redirect(conn, to: ~p"/auth/login")

  def callback(%{assigns: %{ueberauth_auth: %Auth{} = auth}} = conn, _params) do
    provider = to_string(auth.provider)

    case Accounts.upsert_user(auth, provider) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Welcome, #{user.name || user.email || "User"}!")
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Github login failed")
        |> redirect(to: ~p"/auth/login")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Github login canceled")
    |> redirect(to: ~p"/auth/login")
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/auth/login")
  end
end
