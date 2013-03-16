module Kassa
  class BaseRequest
    def initialize(example, options)
      @example = example
      @controller = example.controller
      @options = {format: :json}
      merge_default_options(options) 
      fake_valid_data
      allowed
    end
    def forbidden
      @forbidden = true
      self
    end
    def allowed
      @forbidden = false
      self
    end
    def fake_valid_data
      @valid = true
      self
    end
    def fake_invalid_data
      @valid = false
      self
    end
    def execute
      prepare_message_expectations unless @forbidden
      run_http_query
    end

    protected
    def prepare_message_expectations 
      #NO-OP
    end
    def run_http_query
      raise 'Run HTTP query should be overridden in a subclass to the actual executed HTTP method'
    end
    def merge_default_options(options)
      return if options.nil?
      @options.merge! options
    end
  end
  class IndexRequest < BaseRequest
    def initialize(example, resources, options)
      super example, options
      @resources = resources
    end

    protected
    def run_http_query
      @example.get :index, @options
    end
    def prepare_message_expectations 
      super
      @controller.should_receive(:respond_with).with(@resources).and_call_original
    end
  end
  class SingleEntityRequest < BaseRequest
    def initialize(example, resource, options={})
      super example, options
      @resource = resource
    end
    
    protected
    def prepare_message_expectations
      super
      @controller.should_receive(:respond_with).with(@resource).and_call_original
      fake_errors unless @valid
    end
    def fake_errors
      @resource.should_receive(:errors).at_least(:once).and_call_original
      @resource.errors.add @resource.attributes.first.first.to_sym, :fake_error
    end
  end 
  class IdEntityRequest < SingleEntityRequest
    def initialize(example, resource, options={})
      super example, resource, options
      ensure_id_in_options
    end
    protected
    def ensure_id_in_options
      @options[:id]= @resource.id || 1 if @options[:id].nil?
    end
    def prepare_message_expectations
      super
      @resource.class.should_receive(:find).with("#{@options[:id]}").and_return @resource
    end
  end
  class CreateRequest < SingleEntityRequest
    def run_http_query
      @example.post :create, @options
    end
    protected
    def prepare_message_expectations
      super
      @resource.class.should_receive(:create).and_return @resource if @resource.class.respond_to? :create
    end
  end
  class UpdateRequest < IdEntityRequest
    def run_http_query
      @example.put :update, @options
    end

    protected
    def prepare_message_expectations
      super
      @resource.should_receive(:update_attributes).and_return @valid
    end
  end
  class ShowRequest < IdEntityRequest
    def run_http_query
      @example.get :show, @options
    end
  end
  class DestroyRequest < IdEntityRequest
    def run_http_query
      @example.delete :destroy, @options
    end
  end
  class CurrentUserRequest < SingleEntityRequest
    def run_http_query
      @example.get :current, @options
    end
    protected
    def prepare_message_expectations
      super
      @controller.should_receive(:current_user).at_least(:once).and_return @resource
    end
  end
end
