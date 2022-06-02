defmodule TiktokShop.ProductsStatus do
  def all, do: 0
  def draft, do: 1
  def pending, do: 2
  def failed, do: 3
  def live, do: 4
  def seller_deactivate, do: 5
  def platform_deactivated, do: 6
  def freeze, do: 7

  def deleted, do: 8

  def enum do
    [
      all(),
      draft(),
      pending(),
      failed(),
      live(),
      seller_deactivate(),
      platform_deactivated(),
      freeze(),
      deleted()
    ]
  end
end
