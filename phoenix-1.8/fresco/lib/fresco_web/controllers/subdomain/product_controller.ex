defmodule FrescoWeb.Subdomain.ProductController do
  use FrescoWeb, :controller

  alias Fresco.Products
  alias Fresco.Accounts

  def index(conn, _params) do
    tenant = conn.private[:subdomain]
    products = Products.list_products(tenant)
    account = Accounts.get_account!(tenant)

    render(conn, "index.html", %{
      subdomain: tenant,
      products: products,
      brand_colour: account.brand_colour
    })
  end
end
