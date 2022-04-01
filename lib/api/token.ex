defmodule TiktokShop.Token do
  @moduledoc """
  Support exchange access token and refresh token APIs
  """

  alias TiktokShop.Client
  @endpoint "https://auth.tiktok-shops.com"

  @doc """
  Exchange code for access token

  Reference: https://bytedance.feishu.cn/docs/doccnROmkE6WI9zFeJuT3DQ3YOg#qYtWHF
  """
  @get_access_token_schema %{
    auth_code: [type: :string, required: true],
    grant_type: [type: :string, default: "authorized_code"]
  }
  def get_access_token(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_access_token_schema),
         {:ok, client} <- Client.new([{:endpoint, @endpoint} | opts]) do
      data = Map.put(data, :app_secret, get_app_secret(opts))
      Client.post(client, "/api/token/getAccessToken", nil, query: data)
    end
  end

  @doc """
  Exchange refresh token for new access token

  Reference: https://bytedance.feishu.cn/docs/doccnROmkE6WI9zFeJuT3DQ3YOg#bG2h09
  """
  @refresh_token_schema %{
    refresh_token: [type: :string, required: true],
    grant_type: [type: :string, default: "refresh_token"]
  }
  def refresh_token(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @refresh_token_schema),
         {:ok, client} <- Client.new([{:endpoint, @endpoint} | opts]) do
      data = Map.put(data, :app_secret, get_app_secret(opts))
      Client.post(client, "/api/token/refreshToken", nil, query: data)
    end
  end

  # extract app_secret from config or options
  defp get_app_secret(opts) do
    TiktokShop.Support.Helpers.get_config()
    |> Map.get(:credential)
    |> Map.merge(opts[:credential] || %{})
    |> Map.get(:app_secret)
  end
end
