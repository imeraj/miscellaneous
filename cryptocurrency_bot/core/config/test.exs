import Config

config :core,
       Core.Repo,
       database: "hedgehog_test",
       exchanges: [
         binance_mock: [
           use_cached_exchange_info: true
         ]
       ]

config :logger,
  level: :error
