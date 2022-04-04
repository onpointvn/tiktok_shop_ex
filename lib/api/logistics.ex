defmodule TiktokShop.Logistics do
  @moduledoc """
  Logistics API
  """

  alias TiktokShop.Client

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
    document_type: [type: :string, default: "SHIPPING_LABEL"],
    document_size: [type: :string]
  }
  def get_shipping_document(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_shipping_document_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/api/logistics/shipping_document", query: data)
    end
  end
end
