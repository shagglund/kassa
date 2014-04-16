class UpdateProductNamesWithSlashes < ActiveRecord::Migration
  def change
    Product.all.each do |product|
      name_pieces = product.name.split('/').map{|n| n.strip}
      name_base = name_pieces.shift
      product.name = name_pieces.any? ? "#{name_base} (#{name_pieces.join(', ')})" : name_base
      product.save!
    end
  end
end
