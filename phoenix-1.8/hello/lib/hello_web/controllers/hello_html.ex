defmodule HelloWeb.HelloHTML do
  @moduledoc """
  This module contains pages rendered by HelloController.

  See the `hello_html` directory for all templates available.
  """
  use HelloWeb, :html

  embed_templates "hello_html/*"
end
