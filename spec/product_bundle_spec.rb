RSpec.describe ProductBundle do

  describe '#new' do
    it 'if valid, will be binded to products' do
      product = Product.new(name: 'Image1', code: 'IMG1')
      bundle = described_class.new(product: product, quantity: 5, amount: 450)
      expect(product.bundles).to eq([bundle])
    end

    it 'validates bundle count uniqueness' do
      product = Product.new(name: 'Image2', code: 'IMG2')
      described_class.new(product: product, quantity: 5, amount: 450)
      expect { described_class.new(product: product, quantity: 5, amount: 500) }.to raise_error(QuantityExistsError)
    end

    it 'will raise an exception if product is not an instance of Product' do
      expect { described_class.new(product: 'a', quantity: 5, amount: 500) }.to raise_error(ArgumentError)
    end

    it 'will raise an exception if quantity is not numeric' do
      product = Product.new(name: 'Image3', code: 'IMG3')
      expect { described_class.new(product: product, quantity: 'a', amount: 500) }.to raise_error(ArgumentError)
    end

    it 'will raise an exception if amount is not numeric' do
      product = Product.new(name: 'Image4', code: 'IMG4')
      expect { described_class.new(product: product, quantity: 10, amount: '550') }.to raise_error(ArgumentError)
    end
  end

  describe '#quantity' do
    it 'attribute' do
      product = Product.new(name: 'Image5', code: 'IMG5')
      bundle = described_class.new(product: product, quantity: 5, amount: 500)
      expect(bundle.quantity).to eq(5)
    end
  end

  describe '#amount' do
    it 'attribute' do
      product = Product.new(name: 'Image6', code: 'IMG6')
      bundle = described_class.new(product: product, quantity: 5, amount: 500)
      expect(bundle.amount).to eq(500)
    end
  end

  describe '#product' do
    it 'attribute' do
      product = Product.new(name: 'Image7', code: 'IMG7')
      bundle = described_class.new(product: product, quantity: 5, amount: 500)
      expect(bundle.product).to eq(product)
    end
  end

  describe '::all' do
    it 'includes all bundles' do
      product1 = Product.new(name: 'Text', code: 'TXT')
      product2 = Product.new(name: 'Website', code: 'WEB')
      product3 = Product.new(name: 'Radio', code: 'RAD')
      product_1_bundle_1 = described_class.new(product: product1, quantity: 5, amount: 450)
      product_1_bundle_2 = described_class.new(product: product1, quantity: 10, amount: 800)
      product_2_bundle_1 = described_class.new(product: product2, quantity: 3, amount: 427.50)
      product_2_bundle_2 = described_class.new(product: product2, quantity: 6, amount: 810)
      product_2_bundle_3 = described_class.new(product: product2, quantity: 9, amount: 1147.50)
      product_3_bundle_1 = described_class.new(product: product3, quantity: 3, amount: 570)
      product_3_bundle_2 = described_class.new(product: product3, quantity: 5, amount: 900)
      product_3_bundle_3 = described_class.new(product: product3, quantity: 9, amount: 1530)
      expect(described_class.all).to include(
        product_1_bundle_1, product_1_bundle_2, product_2_bundle_1, product_2_bundle_2,
        product_2_bundle_3, product_3_bundle_1, product_3_bundle_2, product_3_bundle_3
      )
    end
  end
end