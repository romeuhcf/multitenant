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


  test "I can create two accounts" do
	ActiveRecord::Migrator.migrate_on_connection(Dummy::Application.paths['db/migrate'].existent)
	ActiveRecord::Base.establish_connection(ActiveRecord::Base.get_config)
	

	Account.delete_all

	foo = Account.create!(:subdomain => 'foo')
	bar = Account.create!(:subdomain => 'bar')

	foo.database_recreate
	bar.database_recreate
	
	foo.database_migrate(Dummy::Application.paths['db/migrate'].existent)
	bar.database_migrate(Dummy::Application.paths['db/migrate'].existent)

	bar.set_as_current

	Post.create!(:message => 'bar post 1')
	Post.create!(:message => 'bar post 2')
	assert Post.count == 2, 'bar should have 2 posts'




	foo.on_mydb do
		Post.create!(:message => 'foo post 1')
		assert Post.count == 1, 'foo should have 1 posts'
	end
	Post.create!(:message => 'bar post 3')
	assert Post.count == 3, 'bar should have 3 posts'

	bar.on_mydb do
		Post.create!(:message => 'bar post 4')
		assert Post.count == 4, 'bar should have 4 posts'
	end
	Post.create!(:message => 'bar post 5')
	assert Post.count == 5, 'bar should have 5 posts'
	foo.set_as_current
	Post.create!(:message => 'foo post 2')
	assert Post.count == 2, 'foo should have 2 posts'
	bar.set_as_current
	Post.create!(:message => 'bar post 6')
	assert Post.count == 6, 'bar should have 6 posts'

	#bar.database_drop
	#foo.database_drop
  end
end
