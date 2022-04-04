defmodule TiktokShop.Order.OrderStatus do
  def unpaid, do: 100

  def awaiting_shipment, do: 111

  def awaiting_collection, do: 112

  def in_transit, do: 121

  def delivered, do: 122

  def completed, do: 130

  def cancelled, do: 140

  def enum do
    [
      unpaid(),
      awaiting_shipment(),
      awaiting_collection(),
      in_transit(),
      delivered(),
      completed(),
      cancelled()
    ]
  end
end

defmodule TiktokShop.Order do
  @moduledoc """
  Order APIs

  Reference https://bytedance.feishu.cn/wiki/wikcntMLczW460imZUfYqaa1Dng#4bXnAs
  """

  alias TiktokShop.Client

  alias TiktokShop.Order.OrderStatus

  @sort_by_values ["CREATE_TIME", "UPDATE_TIME"]

  # Sort type: 1 (desc), 2 (asc)
  @sort_type_values [1, 2]

  @doc """
  Get order list

  Parameters

  - `create_time_from[integer]`: UNIX timestamp
  - `create_time_to[integer]`: UNIX timestamp
  - `update_time_from[integer]`: UNIX timestamp
  - `update_time_to[integer]`: UNIX timestamp
  - `order_status[integer]`: value must be one of the following values:
    + 100: unpaid
    + 111: awaiting_shipment
    + 112: awaiting_collection
    + 121: in_transit
    + 122: delivered
    + 130: completed
    + 140: cancelled
  - `cursor[string]`
  - `sort_by[string]`: value must be one of the following values: CREATE_TIME, UPDATE_TIME
  - `sort_type[integer]`: value must be one of the following values: 1 (desc), 2 (asc)
  - `page_size[integer]`

  Reference: https://bytedance.feishu.cn/wiki/wikcntMLczW460imZUfYqaa1Dng#jIY8hJ
  """
  @get_order_list_schema %{
    create_time_from: :integer,
    create_time_to: :integer,
    update_time_from: :integer,
    update_time_to: :integer,
    order_status: [type: :integer, in: OrderStatus.enum()],
    cursor: :string,
    sort_by: [type: :string, in: @sort_by_values],
    sort_type: [type: :integer, in: @sort_type_values],
    page_size: [type: :integer, number: [min: 1, max: 50]]
  }
  def get_order_list(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_order_list_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/api/orders/search", data)
    end
  end

  @doc """
  Get order detail

  Reference: https://bytedance.feishu.cn/wiki/wikcntMLczW460imZUfYqaa1Dng#kOhXuO
  """
  @get_order_detail_schema %{
    order_id_list: [type: {:array, :string}, required: true, length: [max: 50]]
  }
  def get_order_detail(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_order_detail_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/api/orders/detail/query", data)
    end
  end
end
