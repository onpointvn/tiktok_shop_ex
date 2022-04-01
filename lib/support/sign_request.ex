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
      Map.new(env.query)
      |> build_common_params(env, credential)
      |> Enum.to_list()

    %{env | query: common_params}
  end

  defp build_common_params(params, env, credential) do
    common_params =
      params
      |> Map.merge(%{
        app_key: credential.app_key,
        timestamp: "#{:os.system_time(:second)}",
        shop_id: credential.shop_id
      })
      |> Helpers.clean_nil()

    params =
      Map.merge(params, common_params)
      |> Helpers.clean_nil()

    signature = Helpers.sign(params, env.opts[:api_name], credential.app_secret)

    common_params
    |> Map.merge(%{sign: signature, access_token: credential.access_token})
    |> Helpers.clean_nil()
  end
end
