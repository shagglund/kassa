class BuyObserver < ActiveRecord::Observer
  observe :buy

  def before_create(record)
    record.buy_entries.each do |entry|
      record.price += entry.amount * entry.product.price
    end
  end

  def after_create(record)
    return false unless update_buyer(record)
    update_products(record)
  end

  private
    def update_buyer(record)
      record.buyer.buy_count += record.product_count
      record.buyer.balance -= record.price
      record.buyer.time_of_last_buy = DateTime.now
      record.buyer.save_without_auditing
    end

    def update_products(record)
      record.buy_entries.each do |entry|
        entry.product.materials.each do |product_entry|
          product_entry.material.stock -= entry.amount * product_entry.amount
          product_entry.material.save_without_auditing
        end
      end
    end
end