defmodule Webhooks do
  def run do
    webhooks = [
      {"https://customer-1.app/webhooks", %{order_id: "1", status: "SHIPPED"}},
      {"https://customer-2.app/webhooks", %{order_id: "2", status: "SHIPPED"}},
      {"https://customer-3.app/webhooks", %{order_id: "3", status: "SHIPPED"}},
      {"https://customer-4.app/webhooks", %{order_id: "4", status: "SHIPPED"}},
      {"https://customer-5.app/webhooks", %{order_id: "5", status: "SHIPPED"}},
      {"https://customer-6.app/webhooks", %{order_id: "6", status: "SHIPPED"}},
      {"https://customer-7.app/webhooks", %{order_id: "7", status: "SHIPPED"}},
      {"https://customer-8.app/webhooks", %{order_id: "8", status: "SHIPPED"}}
    ]

    Enum.each(webhooks, fn {url, payload} ->
      Webhooks.Manager.publish_webhook(url, payload)
    end)
  end
end
