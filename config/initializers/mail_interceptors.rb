# frozen_string_literal: true

# Mail Interceptors Configuration

# Require interceptor classes
require Rails.root.join("app", "interceptors", "development_mail_interceptor")
require Rails.root.join("app", "interceptors", "production_mail_interceptor")

# Register interceptors based on environment
if Rails.env.development?
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end

if Rails.env.production?
  ActionMailer::Base.register_interceptor(ProductionMailInterceptor)
end
