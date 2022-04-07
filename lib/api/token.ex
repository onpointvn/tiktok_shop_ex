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
    app_key: [type: :string, required: true],
    app_secret: [type: :string, required: true],
    auth_code: [type: :string, required: true],
    grant_type: [type: :string, default: "authorized_code"]
  }
  def get_access_token(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_access_token_schema),
         {:ok, client} <- Client.new([{:endpoint, @endpoint} | opts]) do
      Client.post(client, "/api/token/getAccessToken", data)
    end
  end

  @doc """
  Exchange refresh token for new access token

  Reference: https://bytedance.feishu.cn/docs/doccnROmkE6WI9zFeJuT3DQ3YOg#bG2h09
  """
  @refresh_token_schema %{
    app_key: [type: :string, required: true],
    app_secret: [type: :string, required: true],
    refresh_token: [type: :string, required: true],
    grant_type: [type: :string, default: "refresh_token"]
  }
  def refresh_token(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @refresh_token_schema),
         {:ok, client} <- Client.new([{:endpoint, @endpoint} | opts]) do
      Client.post(client, "/api/token/refreshToken", data)
    end
  end
end
