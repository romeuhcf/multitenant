module MultiTenant
	module ActiveRecord
		class Base < ::ActiveRecord::Base
			self.abstract_class = true
		end
	end
end
