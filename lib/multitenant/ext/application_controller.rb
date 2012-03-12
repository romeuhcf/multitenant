module MultiTenant
  class ApplicationController < ActionController::Base
    protect_from_forgery
    acts_as_tenant_controller
  end
end
