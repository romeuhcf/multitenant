module MultiTenant
	module MiddleWare
		class AccountSetter
			def initialize(app, reserved_subdomain = [], fallback_url = nil)
				@app = app
				
			end

			def call(env)
				@req = ::Rack::Request.new(env)
				puts '- ' * 40
				puts @req.subdomain
				puts @req
				puts '- ' * 40
				@app.call(env)
			end
		end
	end

end
