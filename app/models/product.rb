class Product < ActiveRecord::Base

  #also has a description but it's not validated in any way for now
  validates :name, presence: true, uniqueness: true


  def buy(amount)
    raise :not_implemented
  end

  private
  def self.as_hash_with_internationalization(type, values, model=self.name.underscore)
    hash = {}
    values.each do |value|
      hash[value] = I18n.t("activerecord.attributes.#{model}.#{type}s.#{value}")
    end
    hash
  end

end
