class ProductEntryObserver < ActiveRecord::Observer
  observe :product_entry

  def after_save(record)
    record.product.updated_at = DateTime.now
    record.product.save!
  end
end