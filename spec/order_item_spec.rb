RSpec.describe OrderItem do

  let(:product) { instance_double(Product, name: 'ProductXYZ', code: 'PRODXYZ', bundles: []) }
  let(:bundle) { instance_double(ProductBundle, product: product, quantity: 5, amount: 450) }
  let(:order) { Order.new(code: product.code, quantity: 13) }
  let(:order_item) { instance_double(OrderItem, order: order, bundle: bundle, quantity: 2) }
  before do
    allow(Product).to receive(:new).and_return(product)
    allow(ProductBundle).to receive(:new).and_return(bundle)
    allow(OrderItem).to receive(:new).and_return(order_item)
    allow_any_instance_of(Order).to receive(:items).and_return([order_item])
  end

  describe '#new' do
    it 'responds to #order' do
      expect(order_item.order).to eq(order)
    end

    it 'responds to #bundle' do
      expect(order_item.bundle).to eq(bundle)
    end
    it 'responds to #quantity' do
      expect(order_item.quantity).to eq(2)
    end

    it 'adds item to orders' do
      expect(order.items).to eq([order_item])
    end
  end

  describe '#total' do
    let!(:product) { Product.new(name: 'ProductXYZ', code: 'PRODXYZ') }
    let!(:bundle) { ProductBundle.new(product: product, quantity: 5, amount: 450) }
    let!(:order) { Order.new(code: product.code, quantity: 13) }
    let!(:order_item) { OrderItem.new(order: order, bundle: bundle, quantity: 2) }
    subject { order_item }
    it 'returns the total of item' do
      expect(subject.total).to eq(900)
    end
  end

  describe '#description' do
    let!(:product) { Product.new(name: 'ProductABC', code: 'PRODABC') }
    let!(:bundle) { ProductBundle.new(product: product, quantity: 5, amount: 900) }
    let!(:order) { Order.new(code: product.code, quantity: 13) }
    let!(:order_item) { OrderItem.new(order: order, bundle: bundle, quantity: 2) }
    subject { order_item }
    it 'returns the total of item' do
      expect(subject.description).to eq('2 x 5 $1800.00')
    end
  end

end