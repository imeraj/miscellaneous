defmodule FrescoWeb.Plugs.Subdmain do
  import Plug.Conn, only: [put_private: 3, halt: 1]

  def init(opts) do
    Map.merge(
      opts,
      %{root_host: FrescoWeb.Endpoint.config(:url)[:host]}
    )
  end

  def call(
        %Plug.Conn{host: host} = conn,
        %{root_host: root_host, subdomain_router: router} = _opts
      ) do
    case extract_subdomain(host, root_host) do
      subdomain when byte_size(subdomain) > 0 ->
        conn
        |> put_private(:subdomain, subdomain)
        |> router.call(router.init({}))
        |> halt()

      _ ->
        conn
    end
  end

  defp extract_subdomain(host, root_host) do
    String.replace(host, ~r/.?#{root_host}/, "")
  end
end
