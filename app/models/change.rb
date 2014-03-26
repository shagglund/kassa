class Change < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  belongs_to :doer, class_name: 'User'

  validates :trackable_id, presence: true
  validates :trackable_type, presence: true
  validates :change, presence: true
  validates :change_note, presence: true
end