defmodule Fresco.UserManager.Auth do
  import Plug.Conn

  def load_current_user(conn, _) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> put_user_token(Guardian.Plug.current_resource(conn))
  end

  defp put_user_token(conn, user) do
    token = Phoenix.Token.sign(conn, "user token", user.id)
    assign(conn, :user_token, token)
  end
end
