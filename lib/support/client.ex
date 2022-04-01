defmodule TiktokShop.Client do
  @moduledoc """
  Process and sign data before sending to Lazada and process response from Lazada
  Proxy could be config

      config :tiktok_shop, :config,
            proxy: "http://127.0.0.1:9090"
  """
  require Logger

  @default_endpoint "https://open-api.tiktokglobalshop.com"
  @doc """
  Create a new client with given credential

  To pass proxy to Hackney use this

      Tesla.client([{Tesla.Middleware.Opts, adapter: [proxy: {'133.18.173.18', 60088}]}])

  **Options**
  - `require_token [boolean]`: does this reqest require access token. Default `true`
  - `endpoint [string]`: custom endpoint
  - `form_false [boolean]`: does this default use `url encoded request`. Default `false`, using JSON request
  """
  def new(opts \\ []) do
    credential_schema = %{
      app_key: [type: :string, required: true],
      app_secret: [type: :string, required: true],
      access_token: :string,
      shop_id: :string
    }

    config = TiktokShop.Support.Helpers.get_config()
    credential = Map.merge(config.credential, opts[:credential] || %{})

    with {:ok, data} <- Contrak.validate(credential, credential_schema) do
      middlewares = [
        {Tesla.Middleware.Timeout, timeout: config.timeout},
        {Tesla.Middleware.BaseUrl, opts[:endpoint] || @default_endpoint},
        {Tesla.Middleware.Opts,
         [
           adapter: [proxy: config.proxy],
           credential: Map.merge(credential, data)
         ]},
        TiktokShop.Support.SignRequest,
        TiktokShop.Support.SaveRequestBody,
        Tesla.Middleware.JSON,
        Tesla.Middleware.Logger
      ]

      client =
        Tesla.client(
          middlewares,
          {Tesla.Adapter.Hackney, recv_timeout: config.timeout}
        )

      {:ok, client}
    end
  end

  @doc """
  Perform a GET request

      get("/users")
      get("/users", query: [scope: "admin"])
      get(client, "/users")
      get(client, "/users", query: [scope: "admin"])
      get(client, "/users", body: %{name: "Jon"})
  """
  @spec get(Tesla.Client.t(), String.t(), keyword()) :: {:ok, any()} | {:error, any()}
  def get(client, path, opts \\ []) do
    client
    |> Tesla.get(path, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  @doc """
  Perform a POST request.

      post("/users", %{name: "Jon"})
      post("/users", %{name: "Jon"}, query: [scope: "admin"])
      post(client, "/users", %{name: "Jon"})
      post(client, "/users", %{name: "Jon"}, query: [scope: "admin"])
  """
  @spec post(Tesla.Client.t(), String.t(), map(), keyword()) :: {:ok, any()} | {:error, any()}
  def post(client, path, body, opts \\ []) do
    client
    |> Tesla.post(path, body, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  defp process(response) do
    module =
      Application.get_env(:tiktok_shop, :config, [])
      |> Keyword.get(:response_handler, __MODULE__)

    module.handle_response(response)
  end

  @doc """
  Default response handler for request, user can customize by pass custom module in config
  """
  def handle_response(response) do
    case response do
      {:ok, %{body: body}} ->
        case body do
          %{"code" => 0} ->
            {:ok, body}

          _ ->
            {:error, body}
        end

      {_, _result} ->
        Logger.info("TiktokShop connection error: #{inspect(response)}")

        {:error, %{type: :system_error, response: response}}
    end
  end
end
