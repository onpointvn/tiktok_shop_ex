defmodule TiktokShop.Category do
  @moduledoc """
  Tiktok Category APIs implementation
  """

  alias TiktokShop.Client

  @doc """
  Get category from tiktok

  Reference: https://bytedance.feishu.cn/docs/doccnDyz5Bbk26iOdejbBRBlLrb#jIY8hJ
  """
  def get_category(opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/products/categories")
    end
  end

  @doc """
  Get category's attribute for given attribute

  Reference: https://bytedance.feishu.cn/docs/doccnDyz5Bbk26iOdejbBRBlLrb#WBz4V0
  """
  def get_category_attributes(category_id, opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/products/attributes",
        query: [category_id: category_id]
      )
    end
  end

  @doc """
  Get category's rule

  Reference: https://bytedance.feishu.cn/docs/doccnDyz5Bbk26iOdejbBRBlLrb#Vo9x7O
  """
  def get_category_attributes(category_id, opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/products/categories/rules",
        query: [category_id: category_id]
      )
    end
  end
end
