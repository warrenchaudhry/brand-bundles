module Utils
  def setup_product1(code:, name:)
    product = Product.new(name: name, code: code)
    ProductBundle.new(product: product, quantity: 5, amount: 450)
    ProductBundle.new(product: product, quantity: 10, amount: 800)
    product
  end

  def setup_product2(code:, name:)
    product = Product.new(name: name, code: code)
    ProductBundle.new(product: product, quantity: 3, amount: 427.50)
    ProductBundle.new(product: product, quantity: 6, amount: 810)
    ProductBundle.new(product: product, quantity: 9, amount: 1147.50)
    product
  end

  def setup_product3(code:, name:)
    product = Product.new(name: name, code: code)
    ProductBundle.new(product: product, quantity: 3, amount: 570)
    ProductBundle.new(product: product, quantity: 5, amount: 900)
    ProductBundle.new(product: product, quantity: 9, amount: 1530)
    product
  end
end