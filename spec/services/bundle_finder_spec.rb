RSpec.describe BundleFinder do

  describe 'methods' do
    let(:product) { instance_double(Product, name: 'Item ABC', code: 'ITEM-ABC')}
    let(:product_bundle_1) { instance_double(ProductBundle, product: product, quantity: 5, amount: 450) }
    let(:product_bundle_2) { instance_double(ProductBundle, product: product, quantity: 10, amount: 800) }
    let(:order) { Order.new(code: product.code, quantity: 10) }

    before do
      allow(product).to receive(:bundles).and_return([product_bundle_1, product_bundle_2])
      allow(product_bundle_1).to receive(:product).and_return(product)
      allow(product_bundle_2).to receive(:product).and_return(product)
      allow(Product).to receive(:find_by_code).and_return(product)
      allow(product_bundle_1).to receive(:is_a?).and_return(true)
      allow(product_bundle_2).to receive(:is_a?).and_return(true)
    end

    subject  { described_class.new(order: order) }

    context '.product' do
        it 'returns product instance' do
        expect(subject.product).to eq(product)
      end
    end

    context '.bundles' do
      it 'returns product bundles' do
        expect(subject.bundles).to eq(product.bundles)
      end
    end
  end

  describe '.best_bundles' do
    context 'when it found bundles' do
      it 'will return an array of bundle quantities' do
        product = setup_product3(code: 'PROD-D', name: 'Product D')
        order = Order.new(code: product.code, quantity: 13)
        expect(described_class.new(order: order).best_bundles).to eq([5,5,3])
      end
    end

    context 'when it doesn\'t found any bundles' do
      it 'will return nil' do
        product = setup_product1(code: 'PROD-E', name: 'Product E')
        order = Order.new(code: product.code, quantity: 4)
        expect(described_class.new(order: order).send(:best_bundles)).to be_nil
      end
    end

  end

  describe '.execute' do
    context 'when it found bundles' do
      it 'will return an array of order_items' do
        product = setup_product3(code: 'PROD-F', name: 'Product F')
        order = Order.new(code: product.code, quantity: 13)
        expect(described_class.new(order: order).execute).to eq(order.items)
      end
    end

    context 'when it doesn\'t found any bundles' do
      it 'will return nil' do
        product = Product.new(code: 'PROD-G', name: 'Product G')
        order = Order.new(code: product.code, quantity: 4)
        expect(described_class.new(order: order).execute).to be_nil
      end
    end
  end


end

