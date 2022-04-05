defmodule TiktokShopTest.Api.ProductTest do
  use TiktokShopTest.DataCase
  alias TiktokShop.Product

  setup do
    System.put_env("APP_KEY", "123123")
    System.put_env("APP_SECRET", "9751d6598735babe213e1f5bbe9864cd341b1231")
    :ok
  end

  describe "get product list" do
    test "without params" do
      assert {:error, %{page_size: ["is required"]}} = Product.get_product_list(%{})
    end

    test "without page_number" do
      assert {:error, %{page_number: ["is required"]}} =
               Product.get_product_list(%{page_size: 10})
    end

    test "page_number < 1" do
      assert {:error, %{page_number: ["must be greater than or equal to 1"]}} =
               Product.get_product_list(%{page_size: 10, page_number: 0})
    end

    test "page_size < 1" do
      assert {:error, %{page_size: ["must be greater than or equal to 1"]}} =
               Product.get_product_list(%{page_size: 0, page_number: 1})
    end

    test "page_size > 100" do
      assert {:error, %{page_size: ["must be less than or equal to 100"]}} =
               Product.get_product_list(%{page_size: 1000, page_number: 1})
    end

    test "search status not in list" do
      assert {:error, %{search_status: ["not be in the inclusion list"]}} =
               Product.get_product_list(%{page_size: 10, page_number: 1, search_status: 8})
    end

    test "update time negative" do
      assert {
               :error,
               %{
                 create_time_from: ["must be greater than or equal to 0"],
                 create_time_to: ["must be greater than or equal to 0"],
                 update_time_from: ["must be greater than or equal to 0"],
                 update_time_to: ["must be greater than or equal to 0"]
               }
             } =
               Product.get_product_list(%{
                 page_size: 10,
                 page_number: 1,
                 update_time_from: -1,
                 update_time_to: -1,
                 create_time_from: -1,
                 create_time_to: -1
               })
    end
  end
end
