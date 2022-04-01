defmodule TiktokShop.Token do

  alias TiktokShop.Client
  @endpoint "https://auth.tiktok-shops.com/"

  @get_access_token_schema %{
    auth_code: [type: :string, required: true],
    grant_type: [type: :string, default: "authorized_code"]
  }
  def get_access_token(params, opts \\ []) do
    with {:ok, data} <-  Contrack.validate(params, @get_access_token_schema),
         {:ok, client} <- Client.new([{:endpoint, @endpoint} | opts]) do
      Client.post("/api/token/getAccessToken​")
    end
  end

  def refresh_token(credential) do
  end
end
