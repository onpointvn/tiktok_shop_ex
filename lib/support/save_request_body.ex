defmodule TiktokShop.Support.SaveRequestBody do
  @behaviour Tesla.Middleware
  require Logger

  @impl Tesla.Middleware
  def call(env, next, _) do
    env = %{env | opts: Keyword.put(env.opts, :request_body, env.body)}
    Tesla.run(env, next)
  end
end
