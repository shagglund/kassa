require 'digest/md5'
module ApplicationHelper

  def cache_key_for_users(users)
    ['users', users.length, md5_array_digest(users), max_updated_at(users)]
  end

  def cache_key_for_products(products)
    ['products', products.length, md5_array_digest(products), max_updated_at(products)]
  end

  def cache_key_for_buys(buys)
    ['buys', buys.length, md5_array_digest(buys), max_created_at(buys)]
  end

  def cache_key_for_balance_changes(balance_changes)
    ['balance_changes', balance_changes.length, md5_array_digest(balance_changes), max_created_at(balance_changes)]
  end

  protected
  def max_updated_at(col); col.map(&:updated_at).max.try(:utc); end
  def max_created_at(col); col.map(&:created_at).max.try(:utc); end

  def md5_array_digest(col); Digest::MD5.hexdigest(col.map(&:id).join('-')); end
end
