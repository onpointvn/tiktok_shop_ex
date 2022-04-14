defmodule TiktokShop.Helpers do
  @authorization_endpoint "https://auth.tiktok-shops.com/oauth/authorize"

  @doc """
  Build authorization url with given app_key and state

  Reference: https://bytedance.feishu.cn/docs/doccnROmkE6WI9zFeJuT3DQ3YOg

  Example: https://auth.tiktok-shops.com/oauth/authorize?app_key=123abc&state=123
  """
  @state 123
  def build_authorization_url(app_key, _state) do
    "#{@authorization_endpoint}?app_key=#{app_key}&state=#{@state}"
  end
end
