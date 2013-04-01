shared_examples 'localized group' do |groups|
  it {should ensure_inclusion_of(:group).in_array groups}
  it "should provider localized product group for each group" do
    groups.each do |group|
      subject.class.localized_groups.should have_key(group)
    end
  end
  it "should provide localized product groups by group" do 
    subject.class.localized_groups.should_not be_empty
    subject.class.localized_groups.each_pair do |group, translation|
      translation.should eq I18n.t("activerecord.attributes.#{subject.class.name.underscore}.groups.#{group}")
    end
  end
end
