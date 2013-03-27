class Product < ActiveRecord::Base
  @@groups = %w(beer long_drink cider shot other)
  cattr_reader :groups

  #also has a description but it's not validated in any way for now
  validates :group, inclusion: {in: @@groups}
  validates :name, presence: true, uniqueness: true

  def self.localized_groups
    as_hash_with_internationalization "group", groups
  end

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
