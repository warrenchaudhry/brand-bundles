require 'yaml'
require 'bigdecimal'

class BundlesGenerator
  PRODUCT_BUNDLES_PATH = 'config/bundles.yml'.freeze

  def self.seed(path = PRODUCT_BUNDLES_PATH)
    bundles = YAML.load_file(path)
    bundles['products'].each do |data|
      product = Product.new(name: data['name'], code: data['code'])
      data['bundles'].each do |bundle_info|
        ProductBundle.new(product: product, quantity: Integer(bundle_info['quantity']), amount: BigDecimal(bundle_info['amount'], 2))
      end
    end
  end
end
