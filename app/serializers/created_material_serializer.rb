class CreatedMaterialSerializer < MaterialSerializer
  root :material 
  has_many :products, embed: :ids, include: true
end
