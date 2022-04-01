defmodule TiktokShop.Shop do
  @moduledoc """
  Shop Apis
  """

  alias TiktokShop.Client

  @endpoint "https://open-api.tiktokglobalshop.com"

  @doc """
  Get authorized shop list

  Reference: https://bytedance.feishu.cn/wiki/wikcnuoDNlnr4zwfg2eIOhfnMCd#jN96M1

  `search_status`: 0-all、1-draft、2-pending、3-failed、4-live、5-seller_deactivat、6-platform_deactivated、7-freeze​
  """
  def get_authorized_shop(opts \\ []) do
    with {:ok, client} <- Client.new([{:endpoint, @endpoint} | opts]) do
      Client.get(client, "/api/shop/get_authorized_shop")
    end
  end
end
