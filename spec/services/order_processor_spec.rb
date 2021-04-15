RSpec.describe OrderProcessor do
  describe '#call' do
    it 'will raise an exception if order is blank' do
      order = []
      expect { described_class.new(order).call }.to raise_error(ArgumentError)
    end

    it 'if code is invalid, will return a hash with error description' do
      Product.new(code: 'X1', name: 'Product X1')
      order = [{'10' => 'X21'}]
      expect(described_class.new(order).call).to eq('Product with code \'X21\' not found.')
    end

    it 'if quantity is not numeric, will return a hash with error description' do
      Product.new(code: 'X2', name: 'Product X2')
      order = [{'a' => 'X2'}]
      expect(described_class.new(order).call).to eq("invalid value for Integer(): \"a\"")
    end

    it 'will return \'No available bundle\' description if it doesn\'t found any bundles' do
      Product.new(code: 'X3', name: 'Product X3')
      order = [{'10' => 'X3'}]
      expect(described_class.new(order).call).to eq("10 X3\nNo available bundle")
    end

    describe 'with valid order request' do
      let!(:product1) { setup_product1(name: 'Item ABC', code: 'ITEM-ABC') }
      let!(:product2) { setup_product2(name: 'Item DEF', code: 'ITEM-DEF') }
      let!(:product3) { setup_product3(name: 'Item GHI', code: 'ITEM-GHI') }
      let!(:order_request) { [{ '10' => 'ITEM-ABC'}, {'15' => 'ITEM-DEF'}, {'13' => 'ITEM-GHI' }] }
      let(:result) {
        "10 ITEM-ABC $800.00\n1 x 10 $800.00\n" \
        "15 ITEM-DEF $1957.50\n1 x 9 $1147.50\n1 x 6 $810.00\n" \
        "13 ITEM-GHI $2370.00\n2 x 5 $1800.00\n1 x 3 $570.00"
      }
      it 'will return itemized description' do
        expect(described_class.new(order_request).call).to eq(result)
      end
    end

    describe 'with valid order request but without a matched bundle' do
      let!(:product1) { setup_product1(name: 'Item JKL', code: 'ITEM-JKL') }
      let!(:product2) { setup_product2(name: 'Item MNO', code: 'ITEM-MNO') }
      let!(:order_request) { [{ '10' => 'ITEM-JKL'}, {'7' => 'ITEM-MNO'}] }
      let(:result) {
        "10 ITEM-JKL $800.00\n1 x 10 $800.00\n" \
        "7 ITEM-MNO\nNo available bundle"
      }
      it 'will return itemized description' do
        expect(described_class.new(order_request).call).to eq(result)
      end

    end
  end
end