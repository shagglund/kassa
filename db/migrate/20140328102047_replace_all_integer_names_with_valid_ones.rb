class ReplaceAllIntegerNamesWithValidOnes < ActiveRecord::Migration
  def change
    test_regexp = /\A\d+\z/
    Product.all.each do |p|
      if p.name =~ test_regexp
        p.name = "#{p.name} ForceChanged"
        p.save!
      end
    end
    User.all.each do |p|
      if p.username =~ test_regexp
        p.username = "#{p.username} ForceChanged"
        p.save!
      end
    end
  end
end
