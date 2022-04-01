defmodule TiktokShop.Support.SignRequest do
  @moduledoc """
  Middle ware to sign request before sending to Tiktok server with given credential
  """

  alias TiktokShop.Support.Helpers
  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, _) do
    credential = env.opts[:credential]
    env = prepare_params(env, credential)
    Tesla.run(env, next)
  end

  # other request
  defp prepare_params(env, credential) do
    common_params =
      (env.body || %{})
      |> Map.merge(Map.new(env.query))
      |> build_common_params(env, credential)
      |> Map.merge(Map.new(env.query))
      |> Enum.to_list()

    %{env | query: common_params}
  end

  defp build_common_params(params, env, credential) do
    common_params =
      %{
        app_key: credential.app_key,
        timestamp: "#{:os.system_time(:millisecond)}",
        access_token: credential.access_token,
        shop_id: credential.shop_id
      }
      |> Helpers.clean_nil()

    params =
      Map.merge(params, common_params)
      |> Helpers.clean_nil()

    signature = Helpers.sign(params, env.opts[:api_name], credential.app_secret)
    Map.put(common_params, :sign, signature)
  end
end
