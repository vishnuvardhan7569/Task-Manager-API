# frozen_string_literal: true

# Production Mail Interceptor
class ProductionMailInterceptor
  def self.delivering_email(message)
    return unless Rails.env.production?

    Rails.logger.info "[MAIL INTERCEPTOR] Processing email in production"
    Rails.logger.info "[MAIL INTERCEPTOR] Recipients: #{message.to&.join(', ')}"
    Rails.logger.info "[MAIL INTERCEPTOR] Subject: #{message.subject}"

    message.subject = "[PROD] #{message.subject}"

    message.header["X-Processed-By"] = "ProductionMailInterceptor"
  end
end
