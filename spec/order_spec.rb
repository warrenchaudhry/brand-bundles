RSpec.describe Order do
  let(:product) { instance_double(Product, name: 'ProductXYZ', code: 'PRODXYZ', bundles: []) }
  let(:bundle) { instance_double(ProductBundle, product: product, quantity: 10, amount: 800) }
  let(:order) { Order.new(code: product.code, quantity: 10) }

  before do
    allow(Product).to receive(:new).and_return(product)
    allow(bundle).to receive(:product).and_return(product)
    allow(bundle).to receive(:is_a?).and_return(true)
  end

  subject { order }

  describe '#new' do
    it 'responds to .code' do
      expect(subject.code).to eq(product.code)
    end

    it 'responds to .quantity' do
      expect(subject.quantity).to eq(10)
    end
  end

  describe '#get_bundle_summary' do
    context 'with valid requirements' do
      let(:order_item) { OrderItem.new(order: order, bundle: bundle, quantity: 1) }

      it 'returns a message with the itemized description of order' do
        allow_any_instance_of(BundleFinder).to receive(:execute).and_return([order_item])
        allow(order).to receive(:items).and_return([order_item])
        expect(order.get_bundle_summary).to eq("10 PRODXYZ $800.00\n1 x 10 $800.00")
      end
    end

    context 'without matched bundle' do
      let(:order_item) { OrderItem.new(order: order, bundle: bundle, quantity: 1) }
      let(:order) { Order.new(code: product.code, quantity: 4) }

      it 'returns a message "No available bundle"' do
        allow_any_instance_of(BundleFinder).to receive(:execute).and_return([])
        allow(order).to receive(:items).and_return([])
        expect(order.get_bundle_summary).to eq("4 PRODXYZ\nNo available bundle")
      end
    end
  end
end