Shindo.tests('Rackspace | Storage', ['rackspace']) do

  def assert_method(url, method)
    @service.instance_variable_set "@rackspace_auth_url", url
    returns(method) { @service.send :authentication_method }
  end

  tests('#authentication_method') do
    @service = Fog::Storage::Rackspace.new
  
    assert_method nil, :authenticate_v2

    assert_method 'https://identity.api.rackspacecloud.com', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://identity.api.rackspacecloud.com/v1.1', :authenticate_v1    
    assert_method 'https://identity.api.rackspacecloud.com/v2.0', :authenticate_v2
    
    assert_method 'https://lon.identity.api.rackspacecloud.com', :authenticate_v1    
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v1.1', :authenticate_v1
    assert_method 'https://lon.identity.api.rackspacecloud.com/v2.0', :authenticate_v2
  end
  
  tests('authentication v1') do
    pending if Fog.mocking?

    tests('variables populated').succeeds do
      @service = Fog::Storage::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").nil? }
      returns(true, "identity_service was not used") { @service.instance_variable_get("@identity_service").nil? }
      @service.head_containers
    end
    tests('custom endpoint') do
      @service = Fog::Storage::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v1.0', 
        :rackspace_storage_url => 'https://my-custom-endpoint.com'
        returns(false, "auth token populated") { @service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end

  tests('authentation v2') do
    pending if Fog.mocking?
    
    tests('variables populated').succeeds do
      @service = Fog::Storage::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(false, "path populated") { @service.instance_variable_get("@uri").nil? }
      returns(false, "identity service was used") { @service.instance_variable_get("@identity_service").nil? }
      @service.head_containers
    end
    tests('dfw region').succeeds do
      @service = Fog::Storage::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :dfw
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw\d/) != nil }
      @service.head_containers
    end
    tests('ord region').succeeds do
      @service = Fog::Storage::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord\d/) != nil }
      @service.head_containers
    end
    tests('custom endpoint').succeeds do
      @service = Fog::Storage::Rackspace.new :rackspace_auth_url => 'https://identity.api.rackspacecloud.com/v2.0', 
        :rackspace_storage_url => 'https://my-custom-endpoint.com'
        returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
        returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
  end
  
  tests('default auth') do
    pending if Fog.mocking?
    
    tests('no params').succeeds do
      @service = Fog::Storage::Rackspace.new
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /dfw\d/) != nil }
      @service.head_containers
    end
    tests('specify region').succeeds do
      @service = Fog::Storage::Rackspace.new :rackspace_region => :ord
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true) { (@service.instance_variable_get("@uri").host =~ /ord\d/ ) != nil }
      @service.head_containers
    end    
    tests('custom endpoint') do
      @service = Fog::Storage::Rackspace.new :rackspace_storage_url => 'https://my-custom-endpoint.com'
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /my-custom-endpoint\.com/) != nil }
    end
    tests('rackspace_servicenet') do
      @service = Fog::Storage::Rackspace.new :rackspace_servicenet => true
      returns(true, "auth token populated") { !@service.send(:auth_token).nil? }
      returns(true, "uses custom endpoint") { (@service.instance_variable_get("@uri").host =~ /snet-/) != nil }
    end
  end
    
  tests('account').succeeds do
    pending if Fog.mocking?    
     Fog::Storage[:rackspace].account
  end
end

