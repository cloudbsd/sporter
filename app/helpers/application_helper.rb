module ApplicationHelper
  def localize_date(dt)
    dt.strftime(I18n.t(:"datetime.formats.date"))
  end

  def localize_time(dt)
    dt.strftime(I18n.t(:"datetime.formats.time"))
  end

  def show_price(price)
    number_with_precision(price, precision: 2)
  end
end
