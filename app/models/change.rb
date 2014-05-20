class Change < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  belongs_to :doer, class_name: 'User'

  validates :trackable_id, presence: true
  validates :trackable_type, presence: true
  validates :change, presence: true
  validates :change_note, presence: true

  def self.change_accessor(name, hash_key)
    define_method(name) {self.change[hash_key]}
    define_method("#{name}=") do |value|
      return if self.change && self.change[hash_key] == value
      self.change ||= {}
      self.change_will_change!
      self.change[hash_key] = value
    end
  end
end