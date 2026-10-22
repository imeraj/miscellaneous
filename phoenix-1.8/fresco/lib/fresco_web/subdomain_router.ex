defmodule FrescoWeb.SubdomainRouter do
  use FrescoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FrescoWeb.Layouts, :root}
    plug :put_layout, html: {FrescoWeb.Layouts, :main}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Fresco.UserManager.Pipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrescoWeb.Subdomain do
    pipe_through :browser

    resources "/users", UserController, only: [:new, :create]
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", FrescoWeb.Subdomain do
    pipe_through [:browser, :auth]

    get "/", PageController, :home

    get "/products", ProductController, :index
    delete "/logout", SessionController, :logout
  end
end
