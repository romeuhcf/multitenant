module MultiTenant
  module ActsAs::TenantController
    def self.included(base)
      base.extend(ClassMethods)
    end


    module ClassMethods
      def acts_as_tenant_controller(options = {})
        self.class_eval do
	  before_filter :find_tenant
          include InstanceMethods

	  def self.tenant_class
		Rails.configuration.tenant_class_name.constantize
	  end
        end
      end
    end

    module InstanceMethods
      def find_tenant
        @current_subdomain = Subdomain.subdomain(request) || 'www'
	@current_account = self.class.tenant_class.find_tenant(@current_subdomain)
	self.class.tenant_class.current = @current_account
	puts 'CURRENT SUBDOMAIN ', @current_subdomain, @current_account
	if @current_account.nil?
		redir_url = Rails.configuration.redirect_url_when_tenant_not_found
		if redir_url.is_a? String
			redirect_to redir_url % [@current_subdomain]
		else
			redirect_to redir_url.update({:domain => @current_subdomain})
		end
        end
      end
    end
  end
end
