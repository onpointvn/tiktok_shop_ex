defmodule TiktokShop.ReverseOrder.ReverseActionType do
  @moduledoc """
  Reverse action type
  """

  def cancel, do: 1

  def refund, do: 2

  def return_and_refund, do: 3

  def request_cancel_refund, do: 4

  def enum do
    [cancel(), refund(), return_and_refund(), request_cancel_refund()]
  end
end

defmodule TiktokShop.ReverseOrder.ReasonType do
  @moduledoc """
  Reason type
  """

  def starte_reverse, do: 1

  def reject_apply, do: 2

  def reject_parcel, do: 3

  def enum do
    [starte_reverse(), reject_apply(), reject_parcel()]
  end
end

defmodule TiktokShop.ReverseOrder do
  @moduledoc """
  Reverse Order APIs

  Reference https://bytedance.feishu.cn/docx/doxcnP8OcsBYIF09bG7eG7dkE2d
  """

  alias TiktokShop.Client
  alias TiktokShop.ReverseOrder.ReasonType
  alias TiktokShop.ReverseOrder.ReverseActionType

  @doc """
  Retrieve the reasons seller can use to reject buyer requests,
  including refund-only reject reason/return&refund reject
  reason/return parcel reject reason/buyer's cancellation reject
  reason/seller cancel reason.

  Reference: https://developers.tiktok-shops.com/documents/document/234465
  """
  @get_reverse_reason_schema %{
    reverse_action_type: [type: :integer, in: ReverseActionType.enum()],
    reason_type: [type: :integer, in: ReasonType.enum()]
  }
  def get_reverse_reason(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_reverse_reason_schema),
         {:ok, client} <- Client.new(opts) do
      data = TiktokShop.Support.Helpers.clean_nil(data)
      Client.get(client, "/api/reverse/reverse_reason/list", query: data)
    end
  end

  @doc """
  Cancel order

  Reference: https://developers.tiktok-shops.com/documents/document/234474
  """
  @cancel_order_schema %{
    order_id: [type: :string, required: true],
    cancel_reason_key: [type: :string, required: true]
  }
  def cancel_order(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @cancel_order_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/api/reverse/order/cancel", data)
    end
  end
end
