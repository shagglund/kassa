class ProductSerializer < ActiveModel::Serializer
  attributes :id, :stock, :price, :name, :unit, :group, :description, :buy_count, :last_bought_at, :created_at, :updated_at

  def buy_count
    @buy_count ||= product_buy_scope.count
  end

  def last_bought_at
    @last_bought_at ||= product_buy_scope.maximum(:created_at)
  end

  def include_last_bought_at
    last_bought_at.present?
  end

  protected
  def product_buy_scope
    Buy.includes(:consists_of_products).where(buy_entries: {product_id: object.id})
  end
end