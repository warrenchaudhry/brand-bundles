require_relative 'errors'
class Product
  attr_reader :name, :code
  attr_accessor :bundles

  @all = []
  class << self
    attr_accessor :all

    def count
      all.count
    end

    def find_by_code(code)
      product = all.find { |product| product.code == code }
      raise ProductNotFoundError, code unless product
      product
    end
  end

  def initialize(name:, code:)
    raise ArgumentError, 'product name cannot be blank' if name.nil? || name.empty?
    raise ArgumentError, 'code cannot be blank' if code.nil? || code.empty?
    raise ProductCodeNotUniqueError, code unless validate_uniqueness_of_code(code)
    @name = name
    @code = code
    @bundles = []
    self.class.all << self
  end

  private

  def validate_uniqueness_of_code(code)
    self.class.all.none? { |product| product.code == code }
  end
end
