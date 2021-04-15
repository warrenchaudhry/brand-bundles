class Order

  attr_reader :quantity, :code
  attr_accessor :items

  def initialize(quantity:, code:)
    @quantity = quantity
    @code = code
    @items = []
  end

  def get_bundle_summary
    find_best_bundle
    print_description
  end

  private
  def find_best_bundle
    bundle = BundleFinder.new(order: self).execute
    return if bundle.nil? || bundle.empty?
  end

  def gross_total
    items.inject(0){|sum, item| sum + item.total }
  end

  def print_description
    desc = []
    if items.empty?
      str = [quantity, code].join(' ')
      desc << [str, 'No available bundle']
    else
      desc << [quantity, code, "$#{sprintf('%.2f', gross_total)}"].join(' ')
      items.each do |item|
        desc << [item.description]
      end
    end
    desc.join("\n")
  end
end
