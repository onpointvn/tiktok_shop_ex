defmodule TiktokShop.Support.Helpers do
  @moduledoc """
    Support helpers function for Tiktok API
  """

  @doc """
  Get client config, support runtime config `{:system, "ENV_KEY"}`
  """
  def get_config() do
    options = load_env(:tiktok_shop, :config)

    credential =
      options[:credential]
      |> case do
        nil ->
          nil

        value ->
          Map.new(value)
      end

    %{
      timeout: options[:timeout],
      proxy: options[:proxy],
      credential: credential,
      middlewares: options[:middlewares] || []
    }
  end

  @doc """
  Build signature from request params and api_name
  """
  @spec sign(map(), String.t(), String.t(), atom()) :: String.t()
  def sign(params, api_name, secret_key, algorithm \\ :sha256) do
    data =
      params
      |> Enum.sort_by(&to_string(elem(&1, 0)))
      |> Enum.reduce(api_name, fn
        {_, v}, acc when is_nil(v) -> acc
        {k, v}, acc when is_map(v) -> "#{acc}#{k}#{Jason.encode!(v)}"
        {k, v}, acc -> "#{acc}#{k}#{v}"
      end)

    data = "#{secret_key}#{data}#{secret_key}"

    :crypto.mac(:hmac, algorithm, secret_key, data)
    |> Base.encode16()
    |> String.downcase()
  end

  @doc """
  Clean nil value from map/list recursively

  Example:

  clean_nil(%{a: 1, b: nil, c: [1, 2, nil]})
  #> %{a: 1, c: [1, 2]}
  """
  @spec clean_nil(any) :: any
  def clean_nil(%{__struct__: mod} = param) when is_atom(mod) do
    param
  end

  def clean_nil(%{} = param) do
    Enum.reduce(param, %{}, fn {k, v}, acc ->
      if is_nil(v) do
        acc
      else
        Map.put(acc, k, clean_nil(v))
      end
    end)
  end

  def clean_nil(param) when is_list(param) do
    Enum.reduce(param, [], fn item, acc ->
      case item do
        nil ->
          acc

        # handle keyword list
        {_, nil} ->
          acc

        _ ->
          [clean_nil(item) | acc]
      end
    end)
    |> Enum.reverse()
  end

  def clean_nil(param), do: param

  @doc """
  Load and parser app config from environment
  """
  def load_env(app, field, default \\ nil) do
    Application.get_env(app, field, default)
    |> load_env_value()
  end

  def load_all_env(app) do
    Application.get_all_env(app)
    |> load_env_value()
  end

  defp load_env_value(nil), do: nil

  defp load_env_value({:system, key}), do: System.get_env(key)

  defp load_env_value(value) when is_list(value), do: Enum.map(value, &load_env_value(&1))

  defp load_env_value(%{} = value) do
    value
    |> Enum.map(&load_env_value(&1))
    |> Enum.into(%{})
  end

  defp load_env_value({k, v}), do: {k, load_env_value(v)}

  defp load_env_value(value), do: value
end
