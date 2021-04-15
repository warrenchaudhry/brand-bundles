require 'optparse'
require_relative '../lib/errors'
require_relative '../lib/product'
require_relative '../lib/product_bundle'
require_relative '../lib/order'
require_relative '../lib/order_item'
require_relative '../lib/services/bundle_finder'
require_relative '../lib/services/order_processor'
require_relative '../lib/services/bundles_generator'
require 'byebug'
def setup_products
  # load predefined product bundles from config/bundles.yml
  BundlesGenerator.seed
end

def parse_order(line)
  to_arr = line.
           split(' ').
           reject(&:empty?).
           each_slice(2).
           to_a
  raise ArgumentError, 'invalid input' if to_arr.any? {|a| a.size.odd? }
  order = to_arr.map {|arr| Hash[*arr] }
  validate_order(order)
end

def validate_order(order)
  # find if there are any duplicate product codes (e.g 10 VID 3 IMG 5 VID 4 FLAC)
  # then get the sum of quantities if any
  hashes = order.group_by {|h| h.values.first }
  return order if hashes.values.none? {|hsh| hsh.size > 1 }
  valid_order = []
  hashes.each do |code, orders|
    begin
      if orders.size > 1
        keys = orders.
               map {|h| h.keys.first }.
               map {|val| Integer(val) }
        quantity = keys.inject(0) {|sum, qty| sum + qty }
        valid_order << { quantity => code }
      else
        valid_order << orders.first
      end
    rescue => e
      return e.message
    end
  end
  valid_order
end

begin
  setup_products
  puts "Enter quantity and item code separated by space (e.g. 10 IMG 15 FLAC 13 VID) : "
  ARGF.each do |line|
    order = parse_order(line)
    puts "\nOUTPUT:\n"
    puts '-' * 100
    puts OrderProcessor.new(order).call
    puts '-' * 100
  end

rescue => e
  puts "Error processing order: #{e.message}"
  raise
end

