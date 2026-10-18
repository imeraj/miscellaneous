defmodule FrescoWeb.Subdomain.ProductHTML do
  @moduledoc """
  This module contains pages rendered by ProductController.

  See the `product_html` directory for all templates available.
  """
  use FrescoWeb, :html

  embed_templates "product_html/*"
end
