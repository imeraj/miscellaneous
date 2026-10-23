defmodule GithubAuthWeb.PageController do
  use GithubAuthWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
