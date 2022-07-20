defmodule TiktokShop.Fulfillment.PickupType do
  def pick_up, do: 1
  def drop_off, do: 2

  def enum do
    [
      pick_up(),
      drop_off()
    ]
  end
end

defmodule TiktokShop.Fulfillment do
  alias TiktokShop.Client
  alias TiktokShop.Support.Helpers

  @doc """
  Ship Package

  Parameters

  - `package_id[string]`: The package id. (required)
  - `pick_up_type[int]`: The pickup type. Must be one of the following values:
    + 1: Pick_up
    + 2: Drop_off
  - `pick_up[map]`: Pickup information
    + `pick_up_start_time[int]`: UNIX timestamp
    + `pick_up_end_time[int]`: UNIX timestamp
  - `self_shipment[map]`: For package with SEND_BY_SELLER as delivery_option
    + `tracking_number[string]`: The tracking number
    + `shipping_provider_id[string]`: The shipping provider

  Reference

  https://developers.tiktok-shops.com/documents/document/237442
  """
  @ship_package_schema %{
    package_id: [type: :string, required: true],
    pick_up_type: [type: :integer, in: TiktokShop.Fulfillment.PickupType.enum()],
    pick_up: %{
      pick_up_start_time: :integer,
      pick_up_end_time: :integer
    },
    self_shipment: %{
      tracking_number: [type: :string, required: true],
      shipping_provider_id: [type: :string, required: true]
    }
  }
  @spec ship_package(map(), keyword()) :: {:ok, map()} | {:error, any()}
  def ship_package(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @ship_package_schema),
         {:ok, client} <- Client.new(opts) do
      payload = Helpers.clean_nil(data)
      Client.post(client, "/api/fulfillment/rts", payload)
    end
  end
end
