class ProductSerializer < ActiveModel::Serializer
  attributes :id, :price, :name, :description, :available
  attribute :buy_count, key: 'buyCount'
  attribute :last_bought_at, key: 'lastBoughtAt'
  attribute :created_at, key: 'createdAt'
  attribute :updated_at, key: 'updatedAt'

  def include_last_bought_at
    last_bought_at.present?
  end
end