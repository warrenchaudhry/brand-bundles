class BaseError < StandardError
  attr_accessor :message
end

class ProductNotFoundError < BaseError
  def initialize(code)
    @message = "Product with code '#{code}' not found."
  end
end

class ProductCodeNotUniqueError < BaseError
  def initialize(code)
    @message = "Product with code '#{code}' already exists."
  end
end

class QuantityExistsError < BaseError; end
class BundleNotFoundError < BaseError; end

