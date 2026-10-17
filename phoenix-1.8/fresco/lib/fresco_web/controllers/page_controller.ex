defmodule FrescoWeb.PageController do
  use FrescoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
