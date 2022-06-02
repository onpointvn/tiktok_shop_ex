defmodule TiktokShopTest.ClientTest do
  use TiktokShopTest.DataCase
  require Logger

  defmodule CustomHandler1 do
    def handle_response(response) do
      case response do
        {:ok, %{body: body}} ->
          case body do
            %{"code" => 0} ->
              {:ok, "success"}

            _ ->
              {:error, "error"}
          end

        {_, _result} ->
          Logger.info("TiktokShop connection error: #{inspect(response)}")

          {:error, %{type: :system_error, response: "response"}}
      end
    end
  end

  defmodule CustomHandler2 do
    @moduledoc """
    custom handler return original response
    """
    def handle_response(response) do
      response
    end
  end

  @app_key "123123"
  @app_secret "123456789.123456789.123456789.123456789"
  @api_name "/api/token/getAccessToken"

  describe "test without environment variable" do
    test "new client with credential from config success" do
      System.put_env("APP_KEY", "123123")
      System.put_env("APP_SECRET", "9751d6598735babe213e1f5bbe9864cd341b1231")

      assert {:ok, _client} = TiktokShop.Client.new()
    end

    test "new client with credential from option success" do
      assert {:ok, _client} =
               TiktokShop.Client.new(
                 credential: %{
                   app_key: "123123",
                   app_secret: "9751d6598735babe213e1f5bbe9864cd341b1231"
                 }
               )
    end

    test "new client without config error" do
      System.delete_env("APP_KEY")
      System.delete_env("APP_SECRET")

      assert {:error, %{app_key: ["is required"], app_secret: ["is required"]}} =
               TiktokShop.Client.new()
    end
  end

  describe "Custom response handler" do
    setup do
      System.put_env("APP_KEY", @app_key)
      System.put_env("APP_SECRET", @app_secret)

      config = Application.get_env(:tiktok_shop, :config) || []
      config = Keyword.put(config, :response_handler, TiktokShopTest.ClientTest.CustomHandler1)
      Application.put_env(:tiktok_shop, :config, config)

      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"code" => 0}}
      end)

      :ok
    end

    test "custom response handler handle success response" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"code" => 0}}
      end)

      assert {:ok, client} = TiktokShop.Client.new()

      assert {:ok, "success"} = TiktokShop.Client.get(client, @api_name)
    end

    test "custom response handler handle error response" do
      Tesla.Mock.mock(fn
        %{method: :get} ->
          %Tesla.Env{status: 200, body: %{"code" => 1000}}
      end)

      assert {:ok, client} = TiktokShop.Client.new()
      assert {:error, "error"} = TiktokShop.Client.get(client, @api_name)
    end
  end

  describe "Test sign middleware" do
    setup do
      System.put_env("APP_KEY", @app_key)
      System.put_env("APP_SECRET", @app_secret)

      config = Application.get_env(:tiktok_shop, :config) || []
      config = Keyword.put(config, :response_handler, TiktokShopTest.ClientTest.CustomHandler2)
      Application.put_env(:tiktok_shop, :config, config)

      Tesla.Mock.mock(fn
        client ->
          %{client | body: %{"code" => 0}}
      end)

      :ok
    end

    test "signature valid with no request params" do
      assert {:ok, client} = TiktokShop.Client.new()
      assert {:ok, client} = TiktokShop.Client.get(client, @api_name)

      assert client.query[:sign] ==
               TiktokShop.Support.Helpers.sign(
                 %{
                   app_key: @app_key,
                   timestamp: client.query[:timestamp]
                 },
                 @api_name,
                 @app_secret
               )
    end

    test "signature valid with request params" do
      assert {:ok, client} = TiktokShop.Client.new()

      assert {:ok, client} =
               TiktokShop.Client.get(client, @api_name,
                 query: %{order_id: 1, from_time: "2021-10-01"}
               )

      assert client.query[:sign] ==
               TiktokShop.Support.Helpers.sign(
                 %{
                   app_key: @app_key,
                   timestamp: client.query[:timestamp],
                   order_id: 1,
                   from_time: "2021-10-01"
                 },
                 @api_name,
                 @app_secret
               )
    end

    test "signature should skip request body" do
      assert {:ok, client} = TiktokShop.Client.new()

      assert {:ok, client} =
               TiktokShop.Client.post(client, @api_name, %{order_id: 1000},
                 query: %{order_id: 1, from_time: "2021-10-01"}
               )

      assert client.query[:sign] ==
               TiktokShop.Support.Helpers.sign(
                 %{
                   app_key: @app_key,
                   timestamp: client.query[:timestamp],
                   order_id: 1,
                   from_time: "2021-10-01"
                 },
                 @api_name,
                 @app_secret
               )
    end

    test "signature should skip access_token from params" do
      assert {:ok, client} = TiktokShop.Client.new()

      assert {:ok, client} =
               TiktokShop.Client.get(client, @api_name,
                 query: %{order_id: 1, from_time: "2021-10-01", access_token: "abcdddd"}
               )

      assert client.query[:sign] ==
               TiktokShop.Support.Helpers.sign(
                 %{
                   app_key: @app_key,
                   timestamp: client.query[:timestamp],
                   order_id: 1,
                   from_time: "2021-10-01"
                 },
                 @api_name,
                 @app_secret
               )
    end

    test "signature should skip access_token from credential" do
      assert {:ok, client} = TiktokShop.Client.new(credential: %{access_token: "123"})

      assert {:ok, client} =
               TiktokShop.Client.get(client, @api_name,
                 query: %{order_id: 1, from_time: "2021-10-01"}
               )

      assert client.query[:sign] ==
               TiktokShop.Support.Helpers.sign(
                 %{
                   app_key: @app_key,
                   timestamp: client.query[:timestamp],
                   order_id: 1,
                   from_time: "2021-10-01"
                 },
                 @api_name,
                 @app_secret
               )
    end
  end
end
