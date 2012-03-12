require 'test_helper'




class MultitenantTest < ActiveSupport::TestCase

  module TestEngines
    class NonTenantEngine < ::Rails::Engine; end
    class TenantEngine < ::Rails::Engine;acts_as_tenant_engine; end
    class OtherNonTenantEngine < ::Rails::Engine;  end
    class OtherTenantEngine < ::Rails::Engine; acts_as_tenant_engine; end
  end

  test "truth" do
    assert_kind_of Module, Multitenant
  end

  test "acts_as_tenant_engine gives tenant_engine? true" do
    assert TestEngines::TenantEngine.tenant_engine, "Should be tenant"
    assert TestEngines::OtherTenantEngine.tenant_engine, "Should be tenant"
  end
  test "non acts_as_tenant_engine gives tenant_engine? false" do
    assert !::Rails::Engine.tenant_engine, "Should not be tenant"
    assert !TestEngines::NonTenantEngine.tenant_engine, "Should not be tenant"
    assert !TestEngines::OtherNonTenantEngine.tenant_engine, "Should not be tenant"
  end
  
  test "railties should list tenant_engines" do
    tenant_engine_classes = Rails::Engine::Railties.tenant_engines.collect{|i| i.class }
    assert tenant_engine_classes.include?( MultitenantTest::TestEngines::TenantEngine )
    assert tenant_engine_classes.include?( MultitenantTest::TestEngines::OtherTenantEngine )
    assert !tenant_engine_classes.include?( TestEngines::OtherNonTenantEngine )
    assert !tenant_engine_classes.include?( TestEngines::NonTenantEngine )
  end
end
