defmodule TiktokShopTest.Api.ShopTest do
  use TiktokShopTest.DataCase
  import Tesla.Mock

  @api "/api/shop/get_authorized_shop"
  setup do
    System.put_env("APP_KEY", "123123")
    System.put_env("APP_SECRET", "9751d6598735babe213e1f5bbe9864cd341b1231")

    Tesla.Mock.mock(fn
      %{method: :get} = client ->
        cond do
          String.ends_with?(client.url, @api) and client.query[:access_token] == "abc" ->
            json(
              %{
                code: 0,
                message: "Success",
                request_id: "2021090907000901024505719023004057",
                data: %{
                  shop_list: [
                    %{
                      shop_id: "7494083350427699117",
                      shop_name: "cbtest",
                      region: "GB",
                      type: "1"
                    }
                  ]
                }
              },
              status: 200
            )

          true ->
            json(%{code: 105_000}, status: 401)
        end
    end)

    :ok
  end

  test "get authorized shop without access_token" do
    assert {:error, %{"code" => 105_000}} = TiktokShop.Shop.get_authorized_shop()
  end

  test "get authorized shop with access_token" do
    assert {:ok, %{"data" => %{"shop_list" => _}}} =
             TiktokShop.Shop.get_authorized_shop(credential: %{access_token: "abc"})
  end
end
