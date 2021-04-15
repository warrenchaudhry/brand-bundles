require_relative '../errors'
class BundleFinder
  attr_reader :order, :order_qty, :code, :bundles

  def initialize(order:)
    @order = order
    @order_qty = order.quantity
    @code = order.code
  end

  def execute
    return if best_bundles.nil? || best_bundles.empty?
    build_order_items
  end

  def product
    @product ||= Product.find_by_code(code)
  end

  def bundles
    return [] unless product
    @bundles ||= product.bundles
  end

  def best_bundles
    @best_bundles ||= find_best_bundles
  end

  private

  def find_best_bundles
    quantities = bundles.map(&:quantity)
    return [order_qty] if quantities.include?(order_qty)
    bundle_quantities = quantities.select { |x| x < order_qty }
    get_best_bundles(order_qty, bundle_quantities)
  end

  def get_best_bundles(target, bundle_quantities = [])
    return [] if target.zero?
    return nil if bundle_quantities.none? { |bundle| bundle <= target }
    bundle_quantities = bundle_quantities.sort.reverse
    best_solution = nil
    bundle_quantities.each_with_index do |bundle_qty, idx|
      next if bundle_qty > target

      remainder = target - bundle_qty

      best_remainder = get_best_bundles(remainder, bundle_quantities.drop(idx))

      next if best_remainder.nil?

      this_solution = [bundle_qty] + best_remainder

      best_solution = this_solution if best_solution.nil? || this_solution.count < best_solution.count
    end

    best_solution
  end

  def build_order_items
    return if best_bundles.nil? || best_bundles.empty?
    hsh = best_bundles.each_with_object(Hash.new(0)) { |bdl_qty, hash| hash[bdl_qty] += 1 }
    items = []
    hsh.each do |bdl_qty, order_portion|
      bundle = bundles.find {|bdl| bdl.quantity == bdl_qty }
      raise BundleNotFoundError, "Unable to find bundle with quantity #{bdl_qty}" if bundle.nil?
      items << OrderItem.new(order: order, bundle: bundle, quantity: order_portion)
    end
    items
  end
end
