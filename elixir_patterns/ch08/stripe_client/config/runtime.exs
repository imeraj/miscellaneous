import Config

config :stripe_client, StripeClient.Adapter.HTTP,
  auth_token: System.fetch_env!("STRIPE_AUTH_TOKEN")
