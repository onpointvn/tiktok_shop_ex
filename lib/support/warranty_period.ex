defmodule TiktokShop.WarrantyPeriod do
  def weeks_4, do: 1
  def months_2, do: 2
  def months_3, do: 3
  def months_4, do: 4
  def months_5, do: 5
  def months_6, do: 6
  def months_7, do: 7
  def months_8, do: 8
  def months_9, do: 9
  def months_10, do: 10
  def months_11, do: 11
  def months_12, do: 12
  def years_2, do: 13
  def years_3, do: 14
  def week_1, do: 15
  def weeks_2, do: 16
  def months_18, do: 17
  def years_4, do: 18
  def years_5, do: 19
  def years_10, do: 20
  def lifetime_warranty, do: 21

  def enum do
    [
      weeks_4(),
      months_2(),
      months_3(),
      months_4(),
      months_5(),
      months_6(),
      months_7(),
      months_8(),
      months_9(),
      months_10(),
      months_11(),
      months_12(),
      years_2(),
      years_3(),
      week_1(),
      weeks_2(),
      months_18(),
      years_4(),
      years_5(),
      years_10(),
      lifetime_warranty()
    ]
  end
end
