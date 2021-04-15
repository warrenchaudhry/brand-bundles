require_relative 'errors'
require 'bigdecimal'
class ProductBundle
  attr_reader :product, :quantity, :amount

  @all = []
  class << self
    attr_accessor :all
  end

  def initialize(product:, quantity:, amount:)
    raise ArgumentError, 'product argument is not an instance of Product' unless product.is_a?(Product)
    raise ArgumentError, 'quantity is blank or not an integer' unless quantity.is_a?(Integer)
    raise ArgumentError, 'amount is blank or is not numeric' unless amount.is_a?(Numeric)
    raise QuantityExistsError unless validate_bundle_quantity_uniqueness(product, quantity)
    @product = product
    @quantity = quantity
    @amount = BigDecimal(amount.to_s, 2)
    @product.bundles << self
    self.class.all << self
  end

  private

  def validate_bundle_quantity_uniqueness(product, quantity)
    product.bundles.map(&:quantity).none? { |count| count == quantity }
  end

end
