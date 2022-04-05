defmodule TiktokShop.Shop do
  @moduledoc """
  Shop Apis
  """

  alias TiktokShop.Client

  @endpoint "https://open-api.tiktokglobalshop.com"

  @doc """
  Get authorized shop list

  Reference: https://bytedance.feishu.cn/wiki/wikcnuoDNlnr4zwfg2eIOhfnMCd#jN96M1
  """
  def get_authorized_shop(opts \\ []) do
    with {:ok, client} <- Client.new([{:endpoint, @endpoint} | opts]) do
      Client.get(client, "/api/shop/get_authorized_shop")
    end
  end
end
