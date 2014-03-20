class ProductSerializer < ActiveModel::Serializer
  attributes :id, :price, :name, :description, :available
  attribute :buy_count, key: 'buyCount'
  attribute :last_bought_at, key: 'lastBoughtAt'
  attribute :created_at, key: 'createdAt'
  attribute :updated_at, key: 'updatedAt'

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