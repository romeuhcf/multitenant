module MultiTenant
	module ActsAs
	end
end

require 'multitenant/acts_as/tenant_domain_model'
require 'multitenant/acts_as/tenant_controller'
require 'multitenant/acts_as/tenant_engine'

ActiveRecord::Base.class_eval { include MultiTenant::ActsAs::TenantDomainModel }
ActionController::Base.class_eval { include MultiTenant::ActsAs::TenantController }
Rails::Engine.class_eval { include MultiTenant::ActsAs::TenantEngine }


require 'multitenant/ext/application_controller'
require 'multitenant/ext/rails_engine'
require 'multitenant/ext/active_record_base'

#require 'multitenant/middleware/account_setter' # TODO setar a account através de middleware


