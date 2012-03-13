module MultiTenant
  module ActsAs::TenantDomainModel
    def self.included(base)
      base.extend(ClassMethods)
    end


    module ClassMethods
      def acts_as_tenant_domain_model(options = {})
        configuration = {:column => 'domain', :tenant_model_superclass_name => 'Tenant::ActiveRecord::Base'}
        configuration.update(options) if options.is_a?(Hash)

        # your code will go here
        self.class_eval <<-EOV
	  class_attribute :tenant_model_superclass
          validates_presence_of :#{configuration[:column]}
          validates_uniqueness_of :#{configuration[:column]}
          validates_format_of :#{configuration[:column]} , :with => /^[a-z_][a-z0-9_]{2,}$/

          def self.tenant_name_attribute
	  	'#{configuration[:column]}'
          end 

	  self.tenant_model_superclass = #{configuration[:tenant_model_superclass_name]}
          def self.find_tenant(name)
		  where(tenant_name_attribute => name).first
          end 
          def self.current
            Thread.current[:current_tenant]
          end
         
          def self.current=(tenant)
            Thread.current[:current_tenant] = tenant
            self.tenant_model_superclass.establish_connection current.database_config if tenant
          end
          include InstanceMethods
        EOV
      end
    end

    module InstanceMethods
      def database_config
        cfg = ActiveRecord::Base.configurations[Rails.env]
        @cfg ||= cfg.merge({'database'=> [cfg['database'], self.send(self.class.tenant_name_attribute)].join('_')})
      end
   
      def database_create
	if self.class.tenant_model_superclass.connection.respond_to? :create_database
        	self.class.tenant_model_superclass.connection.create_database(database_config['database'])
	end
        self
      end
   
   
      def database_drop
        if self.class.tenant_model_superclass.connection.respond_to? :drop_database
          self.class.tenant_model_superclass.connection.drop_database(database_config['database'])
        end
        self
      end
   
      def database_recreate
        database_drop
        database_create
      end

      def database_migrate(migrations_path = nil)
	::Rails::Engine::Railties.tenant_engines.collect{|e| e.class}.uniq.each do |engine|
		engine.db_migrate(database_config, migrations_path)
	end
        self
      end
   
      def on_mydb
	old_config = self.class.tenant_model_superclass.get_config
        self.class.tenant_model_superclass.establish_connection(database_config)
        yield
        self.class.tenant_model_superclass.establish_connection(old_config)
      end
   
      def set_as_current
        self.class.current = self
      end
   
    end
  end
end
