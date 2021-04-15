class OrderProcessor
  attr_accessor :errors, :order_items
  attr_reader :order
  # @param :order
  # array of hash to avoid missing items due to identical keys
  # e.g [{ '10' => 'ITEM-ABC'}, {'15' => 'ITEM-DEF'}, {'13' => 'ITEM-GHI' }]
  def initialize(order = [])
    raise ArgumentError, 'Order cannot be blank.' if order.nil? || order.empty?
    @order = order
    @order_items = []
    @errors = []
  end

  def call
    validate_order
    return errors.join("\n") if errors.any?
    place_orders
  end

  private
  def validate_order
    @errors = []
    order.each do |hash|
      quantity = hash.keys.first
      code = hash.values.first.strip.upcase
      @order_items << { code: code, quantity: Integer(quantity) } if Product.find_by_code(code)
    rescue => e
      errors << e.message
    end
    @order_items
  end

  def place_orders
    [].tap do |arr|
      order_items.each do |item|
        arr << Order.new(item).get_bundle_summary
      end
    end.join("\n")
  end
end
