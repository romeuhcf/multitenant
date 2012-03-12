module MultiTenant
  module ActsAs::TenantEngine
    def self.included(base)
      base.extend(ClassMethods)
    end


    module ClassMethods
      def acts_as_tenant_engine(options = {})
	configuration = {:dependencies => [], :subscribable => false} # TODO.. handle tenant_engine configurations
	configuration.update(options) if options.is_a?(Hash)

	self.tenant_engine = true
        self.class_eval do
          include InstanceMethods
	end
      end
    end

    module InstanceMethods
    end
  end
end
