def serialized_resource
  resource.active_model_serializer.new(resource, {}).to_json
end
def resource_name
  resource.class.name.downcase.to_sym
end
def pluralized_resource_name
  resource.class.name.downcase.pluralize.to_sym
end
#resource should be defined in the spec by using let(:resource) as an initializer
#for the actual model being tested
def kassa_request(type, options)
  case type
    when :index then Kassa::IndexRequest.new(self, resources, options)
    when :create then Kassa::CreateRequest.new(self, resource, options)
    when :show then Kassa::ShowRequest.new(self, resource, options)
    when :destroy then Kassa::DestroyRequest.new(self, resource, options)
    when :update then Kassa::UpdateRequest.new(self, resource, options)
    else raise 'Unmapped request type'
  end
end
shared_examples "a single entity json response" do
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should assign resource to a variable named by the resource class" do
    assigns(resource_name).should eq resource
  end
  it "should serialize the resource  as json" do
    response.body.should eq serialized_resource
  end
end

shared_examples "a create with valid data" do |options|
  before(:each){kassa_request(:create, options).fake_valid_data.execute}
  it {should respond_with :created}
  include_examples "a single entity json response"
end

shared_examples "a create with invalid data" do |options|
  before(:each){kassa_request(:create, options).fake_invalid_data.execute}
  include_examples "an unprocessable resource"
end

shared_examples "a forbidden create" do |options|
  before(:each){kassa_request(:create, options).forbidden.fake_valid_data.execute}
  include_examples "a forbidden request"
end

#========== UPDATE EXAMPLES ==========
shared_examples "an update with valid data" do |options|
  before(:each){kassa_request(:update, options).fake_valid_data.execute}
  it {should respond_with :no_content}
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should assign resource to a variable named by the resource class" do
    assigns(resource_name).should eq resource
  end
end

shared_examples "an update with invalid data" do |options|
  before(:each){kassa_request(:update, options).fake_invalid_data.execute}
  include_examples "an unprocessable resource"
end

shared_examples "a forbidden update" do |options|
  before(:each){kassa_request(:update, options).forbidden.fake_valid_data.execute}
  include_examples "a forbidden request"
end

shared_examples "a valid show request" do |options|
  before(:each){kassa_request(:show, options).execute}
  it {should respond_with :success}
  include_examples "a single entity json response"
end
shared_examples "a valid destroy request" do |options|
  before(:each){kassa_request(:destroy, options).execute}
  it {should respond_with :no_content}
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should assign resource to a variable named by the resource class" do
    assigns(resource_name).should eq resource
  end
end
shared_examples "a valid index request" do |options|
  before(:each){kassa_request(:index, options).execute}
  it {should respond_with :success}
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should assign the resources to a variable named by the resource class" do
    assigns(pluralized_resource_name).should eq resources
  end
end
shared_examples "an unauthorized request" do
  it {should respond_with :unauthorized}
  it "should not assign resource to a variable named by the resource class" do
    assigns(resource_name).should be_nil
  end
end
shared_examples "an unauthorized index request" do
  before(:each) {get :index, format: :json}
  include_examples "an unauthorized request"
end
shared_examples "an unauthorized show request" do
  before(:each) {get :show, format: :json, id: 1}
  include_examples "an unauthorized request"
end
shared_examples "an unauthorized update request" do
  before(:each) {put :update, format: :json, id: 1}
  include_examples "an unauthorized request"
end
shared_examples "an unauthorized create request" do
  before(:each) {post :create, format: :json}
  include_examples "an unauthorized request"
end
shared_examples "an unauthorized destroy request" do
  before(:each) {delete :destroy, format: :json, id: 1}
  include_examples "an unauthorized request"
end
shared_examples "a forbidden request" do
  it {should respond_with :forbidden}
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should not assign resource to a variable named by the resource class" do
    assigns(resource_name).should be_nil
  end
end
shared_examples "an unprocessable resource" do
  it {should respond_with :unprocessable_entity}
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should assign resource to a variable named by the resource class" do
    assigns(resource_name).should eq resource
  end
  it "should serialize the errors as json" do
    response.body.should eq({errors: resource.errors.messages}.to_json)
  end
end
#============ AUTHENTICATION ===========
shared_examples "authenticate user" do |user|
  before(:each) do
    user=FactoryGirl.build :user if user.nil?
    controller.should_receive(:authenticate_user!).and_return true if controller.respond_to? :authenticate_user!
    controller.stub(:current_user).and_return user
  end
end
shared_examples "unauthenticate user" do
  before(:each){ controller.should_receive(:authenticate_user!).and_throw :warden, {scope: :user} }
end
shared_examples "authenticate admin" do |user|
  before :each do
    user = FactoryGirl.build(:user, admin: true) if user.nil?
    controller.should_receive(:authenticate_admin!).and_return true if controller.respond_to? :authenticate_admin!
    controller.stub(:current_user).and_return user
  end
end
