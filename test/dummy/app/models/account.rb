
module Tenant
	module ActiveRecord
		class  Base < ::ActiveRecord::Base
			self.abstract_class =true
		end
	end
end

class Account < ActiveRecord::Base
	acts_as_tenant_domain_model :column => 'subdomain', :tenant_model_superclass_name => '::Tenant::ActiveRecord::Base'
end
