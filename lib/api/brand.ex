defmodule TiktokShop.Brand do
  @moduledoc """
  Tiktok brand APIs implementation
  """

  alias TiktokShop.Client

  @doc """
  Get brand from tiktok

  Reference: https://bytedance.feishu.cn/docs/doccnDyz5Bbk26iOdejbBRBlLrb#IPng1X
  """
  def get_brand(opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/api/products/brands")
    end
  end
end
