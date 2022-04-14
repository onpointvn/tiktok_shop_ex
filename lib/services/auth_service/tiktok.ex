defmodule TiktokShop.Services.Tiktok.Auth do
  require Logger
  alias TiktokShop.Helpers
  alias TiktokShop.Token

  @doc """
  Generate Tiktok authorization url
  """
  def get_authorization_url(app, _state) do
    Helpers.build_authorization_url(String.trim(app.app_id), "123")
  end

  @access_token_params_schema %{
    app_key: [type: :string, required: true],
    app_secret: [type: :string, required: true],
    auth_code: [type: :string, required: true]
  }
  def exchange_token(app, params) do
    access_token_params = %{
      app_key: app.app_id,
      app_secret: app.app_secret,
      auth_code: params.code
    }

    credential = [credential: %{access_token: ""}]

    with {:ok, data} <- Contrak.validate(access_token_params, @access_token_params_schema),
         {:ok, auth_data} <- Token.get_access_token(data),
         credential <-
           put_in(credential[:credential].access_token, auth_data["data"]["access_token"]),
         {:ok, shop_info} <- TiktokShop.Shop.get_authorized_shop(credential) do
      {:ok, Map.merge(auth_data, shop_info["data"])}
    end
  end

  def create_channel_params(auth_data, _request) do
    %{
      identifier: to_string(hd(auth_data["shop_list"])["shop_id"]),
      name: hd(auth_data["shop_list"])["shop_name"],
      platform_status: "ACTIVE"
    }
  end

  def create_channel_credential_params(auth_data, _request) do
    expired_at = DateTime.from_unix!(auth_data["data"]["access_token_expire_in"], :second)

    authorization_expired_at =
      DateTime.from_unix!(auth_data["data"]["refresh_token_expire_in"], :second)

    %{
      identifier: to_string(hd(auth_data["shop_list"])["shop_id"]),
      access_token: auth_data["data"]["access_token"],
      refresh_token: auth_data["data"]["refresh_token"],
      expired_at: expired_at,
      authorization_expired_at: authorization_expired_at
    }
  end

  # def refresh_access_token(params, opts \\ []) do
  #   Token.refresh_token(params, opts)
  # end
  @refresh_token_params_schema %{
    app_key: [type: :string, required: true],
    app_secret: [type: :string, required: true],
    refresh_token: [type: :string, required: true]
  }
  def refresh_access_token(app, credential) do
    refresh_token_params = %{
      app_key: app.app_id,
      app_secret: app.app_secret,
      refresh_token: credential.refresh_token
    }

    with {:ok, params_valid} <-
           Contrak.validate(refresh_token_params, @refresh_token_params_schema),
         {:ok, result} <- Token.refresh_token(params_valid) do
      expired_at = DateTime.from_unix!(result["data"]["access_token_expire_in"], :second)

      authorization_expired_at =
        DateTime.from_unix!(result["data"]["refresh_token_expire_in"], :second)

      {:ok,
       %{
         access_token: result["data"]["access_token"],
         refresh_token: result["data"]["refresh_token"],
         expired_at: expired_at,
         authorization_expired_at: authorization_expired_at
       }}
    else
      error ->
        error
    end
  end
end
