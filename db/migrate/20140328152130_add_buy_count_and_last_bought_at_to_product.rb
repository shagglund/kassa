class AddBuyCountAndLastBoughtAtToProduct < ActiveRecord::Migration
  def up
    add_column :products, :buy_count, :integer, default: 0
    add_column :products, :last_bought_at, :datetime

    Product.all.each do |p|
      p.buy_count = BuyEntry.where(product_id: p.id).pluck(:amount).sum
      p.last_bought_at = Buy.includes(:consists_of_products).where(buy_entries: {product_id: p.id}).maximum(:created_at)
      p.save!
    end
  end

  def down
    remove_column :products, :buy_count
    remove_column :products, :last_bought_at
  end
end
