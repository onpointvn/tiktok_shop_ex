defmodule TiktokShop.Product do
  @moduledoc """
  Product api
  """

  alias TiktokShop.Client

  @doc """
  Get product list

  Reference: https://bytedance.feishu.cn/docs/doccnDyz5Bbk26iOdejbBRBlLrb#ytBXoS

  `search_status`: 0-all、1-draft、2-pending、3-failed、4-live、5-seller_deactivat、6-platform_deactivated、7-freeze​
  """
  @get_product_list_schema %{
    search_status: [type: :integer, in: 0..7],
    seller_sku_list: [type: {:array, :string}],
    page_size: [type: :integer, required: true, number: [min: 1, max: 100]],
    page_number: [type: :integer, required: true, number: [min: 1]],
    # timestamp
    update_time_from: [type: :integer, number: [min: 0]],
    update_time_to: [type: :integer, number: [min: 0]],
    create_time_from: [type: :integer, number: [min: 0]],
    create_time_to: [type: :integer, number: [min: 0]]
  }
  def get_product_list(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_product_list_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/api/products/search", nil, query: data)
    end
  end
end
