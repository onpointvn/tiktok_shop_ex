defmodule TiktokShop.Client do
  @moduledoc """
  Process and sign data before sending to Tiktok and process response from Tiktok server
  Proxy could be config

      config :tiktok_shop, :config,
            proxy: "http://127.0.0.1:9090",
            app_key: "",
            app_secret: "",
            timeout: 10_000,
            response_handler: MyModule,
            middlewares: [] # custom middlewares

  Your custom reponse handler module must implement `handle_response/1`
  """
  require Logger

  @default_endpoint "https://open-api.tiktokglobalshop.com"
  @doc """
  Create a new client with given credential.
  Credential can be set using config.

      config :tiktok_shop, :config
            app_key: "",
            app_secret: ""

  Or could be pass via `opts` argument

  **Options**
  - `credential [map]`: app credential for request.
    Credential map follow schema belows

    app_key: [type: :string, required: true],
    app_secret: [type: :string, required: true],
    access_token: :string,
    shop_id: :string


  - `endpoint [string]`: custom endpoint
  """

  def new(opts \\ []) do
    config = TiktokShop.Support.Helpers.get_config()

    proxy_adapter =
      if config.proxy do
        [proxy: config.proxy]
      else
        nil
      end

    with {:ok, credential} <- validate_credential(config.credential, opts[:credential]) do
      options =
        [
          adapter: proxy_adapter,
          credential: credential
        ]
        |> Enum.filter(fn {_, value} -> not is_nil(value) end)

      middlewares = [
        {Tesla.Middleware.BaseUrl, opts[:endpoint] || @default_endpoint},
        {Tesla.Middleware.Opts, options},
        TiktokShop.Support.SignRequest,
        TiktokShop.Support.SaveRequestBody,
        Tesla.Middleware.JSON
      ]

      # if config setting timeout, otherwise use default settings
      middlewares =
        if config.timeout do
          [{Tesla.Middleware.Timeout, timeout: config.timeout} | middlewares]
        else
          middlewares
        end

      {:ok, Tesla.client(middlewares ++ config.middlewares)}
    end
  end

  @credential_schema %{
    app_key: [type: :string, required: true],
    app_secret: [type: :string, required: true],
    access_token: :string,
    shop_id: :string
  }
  defp validate_credential(config_credential, optional_credential) do
    credential =
      cond do
        is_nil(config_credential) ->
          optional_credential

        is_nil(optional_credential) ->
          config_credential

        true ->
          Map.merge(config_credential, optional_credential)
      end

    if is_nil(credential) do
      {:ok, nil}
    else
      Contrak.validate(credential, @credential_schema)
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

  @doc """
  Perform a POST request.

      post("/users", %{name: "Jon"})
      post("/users", %{name: "Jon"}, query: [scope: "admin"])
      post(client, "/users", %{name: "Jon"})
      post(client, "/users", %{name: "Jon"}, query: [scope: "admin"])
  """
  @spec put(Tesla.Client.t(), String.t(), map(), keyword()) :: {:ok, any()} | {:error, any()}
  def put(client, path, body, opts \\ []) do
    client
    |> Tesla.put(path, body, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  @doc """
  Perform a DELETE request

      delete("/users")
      delete("/users", query: [scope: "admin"])
      delete(client, "/users")
      delete(client, "/users", query: [scope: "admin"])
      delete(client, "/users", body: %{name: "Jon"})
  """
  @spec delete(Tesla.Client.t(), String.t(), keyword()) :: {:ok, any()} | {:error, any()}
  def delete(client, path, opts \\ []) do
    client
    |> Tesla.delete(path, [{:opts, [api_name: path]} | opts])
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
        {:error, %{type: :system_error, response: response}}
    end
  end
end
