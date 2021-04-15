RSpec.describe Product do
  describe '#new' do
    it 'will raise an Exception if name is blank' do
      command = -> { described_class.new(name: '', code: 'A') }
      expect(command).to raise_error(ArgumentError)
    end

    it 'will raise an Exception if code is blank' do
      command = -> { described_class.new(name: 'A', code: '') }
      expect(command).to raise_error(ArgumentError)
    end

    it 'validate_uniqueness_of_code' do
      described_class.new(name: 'Product1', code: 'PROD1')
      expect { described_class.new(name: 'Product One', code: 'PROD1') }.to raise_error(ProductCodeNotUniqueError)
    end
  end

  describe '#name' do
    it 'attribute' do
      product2 = described_class.new(name: 'Product 2', code: 'PROD2')
      expect(product2.name).to eq('Product 2')
    end
  end

  describe '#code' do
    it 'attribute' do
      product3 = described_class.new(name: 'Product3', code: 'PROD3')
      expect(product3.code).to eq('PROD3')
    end
  end

  describe '.all' do
    it 'includes all products' do
      product4 = described_class.new(name: 'Image', code: 'IMG')
      product5 = described_class.new(name: 'Audio', code: 'FLAC')
      product6 = described_class.new(name: 'Video', code: 'VID')
      expect(described_class.all).to include(product4, product5, product6)
    end
  end

  describe '.find_by_code' do
    product7 = described_class.new(name: 'Product7', code: 'PROD7')
    it 'can be found by code' do
      expect(described_class.find_by_code('PROD7')).to eq(product7)
    end

    it 'returns nil if it doesn\'t found a match' do
      expect { described_class.find_by_code('LOREM') }.to raise_error(ProductNotFoundError)
    end
  end

  describe '#bundles' do
    it 'returns list of bundles' do
      product = described_class.new(name: 'Product', code: 'PROD')
      bundle1 = ProductBundle.new(product: product, quantity: 3, amount: 500)
      bundle2 = ProductBundle.new(product: product, quantity: 5, amount: 850)
      expect(product.bundles).to eq([bundle1, bundle2])
    end
  end

end