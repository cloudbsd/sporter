module TransactionsHelper
  def show_price(price)
    number_with_precision(price, precision: 2)
  end
end
