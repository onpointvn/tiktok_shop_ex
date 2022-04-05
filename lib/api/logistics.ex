defmodule TiktokShop.Logistics.DocumentType do
  @moduledoc """
  Document types for TikTok shop
  """
  def shipping_label, do: "SHIPPING_LABEL"

  def pick_list, do: "PICK_LIST"

  def sl_pl, do: "SL_PL"

  def enum do
    [
      shipping_label(),
      pick_list(),
      sl_pl()
    ]
  end
end

defmodule TiktokShop.Logistics.DocumentSize do
  @moduledoc """
  Document sizes for TikTok shop
  """
  def a5, do: "A5"

  def a6, do: "A6"

  def enum do
    [
      a5(),
      a6()
    ]
  end
end

defmodule TiktokShop.Logistics do
  @moduledoc """
  Logistics API
  """

  alias TiktokShop.Client
  alias TiktokShop.Logistics.DocumentType
  alias TiktokShop.Logistics.DocumentSize

  @doc """
  Get shipping info

  Reference: https://bytedance.feishu.cn/wiki/wikcnDCHk9oWB9iqsb58BX9Mlkf#ckvNFO
  """
  @get_shipping_info_schema %{
    order_id: [type: :string, required: true]
  }
  def get_shipping_info(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_shipping_info_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/api/logistics/ship/get", query: data)
    end
  end

  @doc """
  Get shipping providers

  Reference: https://bytedance.feishu.cn/wiki/wikcnDCHk9oWB9iqsb58BX9Mlkf#ZIxgfI
  """
  def get_shipping_providers(opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/api/logistics/shipping_providers")
    end
  end

  @doc """
  Update shipping info

  Reference: https://bytedance.feishu.cn/wiki/wikcnDCHk9oWB9iqsb58BX9Mlkf#qYtWHF
  """
  @update_shipping_info_schema %{
    order_id: [type: :string, required: true],
    tracking_number: [type: :string, required: true],
    provider_id: [type: :string, required: true]
  }
  def update_shipping_info(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @update_shipping_info_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/api/logistics/tracking", data)
    end
  end

  @doc """
  Get warehouse list

  Reference: https://bytedance.feishu.cn/wiki/wikcnDCHk9oWB9iqsb58BX9Mlkf#jN96M1
  """
  def get_warehouse_list(opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/api/logistics/get_warehouse_list")
    end
  end

  @doc """
  Get shipping document

  Reference: https://bytedance.feishu.cn/wiki/wikcnDCHk9oWB9iqsb58BX9Mlkf#ebaiqa
  """
  @get_shipping_document_schema %{
    order_id: [type: :string, required: true],
    document_type: [type: :string, in: DocumentType.enum(), required: true],
    document_size: [type: :string, in: DocumentSize.enum()]
  }
  def get_shipping_document(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_shipping_document_schema),
         {:ok, client} <- Client.new(opts) do
      data = TiktokShop.Support.Helpers.clean_nil(data)
      Client.get(client, "/api/logistics/shipping_document", query: data)
    end
  end
end
