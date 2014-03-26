require 'spec_helper'

describe Change do
  it {should belong_to(:doer).class_name('User')}
  it {should belong_to(:trackable)}

  it {should validate_presence_of(:trackable_id)}
  it {should validate_presence_of(:trackable_type)}
  it {should validate_presence_of(:change)}
  it {should validate_presence_of(:change_note)}
end