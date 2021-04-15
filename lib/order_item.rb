class OrderItem
  attr_reader :order, :bundle, :quantity

  @all = []
  class << self
    attr_accessor :all
  end

  def initialize(order:, bundle:, quantity:)
    raise ArgumentError, 'order argument is not an instance of Order' unless order.is_a?(Order)
    raise ArgumentError, 'bundle argument is not an instance of ProductBundle' unless bundle.is_a?(ProductBundle)
    raise ArgumentError, 'quantity is blank or is not numeric' unless quantity.is_a?(Integer)
    @order = order
    @bundle = bundle
    @quantity = quantity

    @order.items << self
  end

  def total
    quantity * bundle.amount
  end

  def description
    [quantity, 'x', bundle.quantity, "$#{sprintf('%.2f', total)}"].join(' ')
  end
end