defmodule TiktokShop.DataCase do
  use ExUnit.CaseTemplate

  setup tags do
    Application.ensure_all_started(:hackney)

    Application.put_env(:tiktok_shop, :config,
      credential: [
        app_key: {:system, "APP_KEY"},
        app_secret: {:system, "APP_SECRET"}
      ]
    )

    Application.put_env(:tesla, :adapter, Tesla.Mock)
    :ok
  end
end
