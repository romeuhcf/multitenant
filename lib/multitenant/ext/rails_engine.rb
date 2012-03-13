module ::Rails
	class Engine

		class_attribute :tenant_engine
		self.tenant_engine = false
		class Railties
			def self.tenant_engines
				self.engines.find_all{|e| e.try(:tenant_engine)}
			end
		
			def self.non_tenant_engines
				self.engines.find_all{|e| !e.try(:tenant_engine)}
			end
			def self.migrate_non_tenant_engines(logger = nil, verbose = false)
				self.non_tenant_engines.collect(&:class).uniq.each do |engine|
					engine.db_migrate(logger, verbose)
				end
			end
			def self.migrate_tenant_engines(logger = nil, verbose = false)
				self.tenant_engines.collect(&:class).uniq.each do |engine|
					engine.db_migrate(logger, verbose)
				end
			end
		end
	end
end
