def serialized_resource
  resource.active_model_serializer.new(resource, {}).to_json
end
def resource_name
  resource.class.name.downcase.to_sym
end
def pluralized_resource_name
  resource.class.name.downcase.pluralize.to_sym
end
shared_examples "a single entity json response" do
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should serialize the resource  as json" do
    response.body.should eq serialized_resource
  end
end
shared_examples "fake resource errors before each" do
  before :each do
    resource.should_receive(:errors).at_least(:once).and_call_original
    resource.errors.add resource.attributes.first.first.to_sym, :fake_error
  end
end

shared_examples "setup create request before each" do
  let(:fake_params){double.as_null_object}
  before(:each) do
    resource.class.should_receive(:create).and_return resource
    controller.stub(:params).and_return fake_params
    fake_params.should_receive(:require).with(resource_name).and_return fake_params
  end
end
shared_examples "execute create request before each" do
  before(:each) { post :create, format: :json }
end
shared_examples "a create with valid data" do
  include_examples "setup create request before each"
  include_examples "execute create request before each"
  it {should respond_with :created}
  include_examples "a single entity json response"
end

shared_examples "a create with invalid data" do
  include_examples "fake resource errors before each"
  include_examples "setup create request before each"
  include_examples "execute create request before each"
  include_examples "an unprocessable resource"
end

shared_examples "a forbidden create" do 
  before(:each){post :create, format: :json}
  include_examples "a forbidden request"
end

#========== UPDATE EXAMPLES ==========
shared_examples "setup update request before each" do
  let(:fake_params){double.as_null_object}
  before(:each) do
    resource.should_receive(:update_attributes).and_return resource
    resource.class.should_receive(:find).and_return resource
    controller.stub(:params).and_return fake_params
    fake_params.should_receive(:require).with(resource_name).and_return fake_params
  end
end
shared_examples "execute update request before each" do
  before(:each){put :update, format: :json, id: 1}
end
shared_examples "an update with valid data" do
  include_examples "setup update request before each"
  include_examples "execute update request before each"
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

shared_examples "an update with invalid data" do
  include_examples "fake resource errors before each"
  include_examples "setup update request before each"
  include_examples "execute update request before each"
  include_examples "an unprocessable resource"
end

shared_examples "a forbidden update" do |options|
  before(:each) {put :update, format: :json, id: 1}
  include_examples "a forbidden request"
end

shared_examples "a valid show request" do |options|
  before :each do
    resource.class.should_receive(:find).and_return resource
    get :show, format: :json, id: 1
  end
  it {should respond_with :success}
  include_examples "a single entity json response"
end
shared_examples "a valid destroy request" do |options|
  before :each do
    resource.class.should_receive(:find).and_return resource
    delete :destroy, format: :json, id: 1
  end
  it {should respond_with :no_content}
  it "should respond with content type application/json" do
    response.content_type.should eq "application/json"
  end
  it "should assign resource to a variable named by the resource class" do
    assigns(resource_name).should eq resource
  end
end
shared_examples "a valid index request" do |options={}|
  before(:each) { get :index, {format: :json}.merge(options)}
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
  let(:current_user) do
    if user.nil?
      FactoryGirl.build :user
    else 
     user
    end
  end
  before(:each) do
    controller.stub(:authenticate_user!).and_return true if controller.respond_to? :authenticate_user!
    controller.stub(:current_user).and_return current_user
  end
end
shared_examples "unauthenticate user" do
  before(:each){ controller.stub(:authenticate_user!).and_throw :warden, {scope: :user} }
end
shared_examples "authenticate admin" do |user|
  before :each do
    user = FactoryGirl.build(:user, admin: true) if user.nil?
    controller.stub(:authenticate_admin!).and_return true if controller.respond_to? :authenticate_admin!
    controller.stub(:current_user).and_return user
  end
end
