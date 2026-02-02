# frozen_string_literal: true

# Development Mail Interceptor
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    return unless Rails.env.development?

    original_to = message.to&.join(", ") || "unknown"
    Rails.logger.info "[MAIL INTERCEPTOR] Intercepting email in development"
    Rails.logger.info "[MAIL INTERCEPTOR] Original recipients: #{original_to}"
    Rails.logger.info "[MAIL INTERCEPTOR] Subject: #{message.subject}"

    interceptor_address = ENV.fetch("MAIL_INTERCEPTOR_ADDRESS", "dev@test.com")

    message.header["X-Original-To"] = original_to

    # Redirect to interceptor address
    message.to = [ interceptor_address ]
    message.subject = "[DEV] #{message.subject}"

    Rails.logger.info "[MAIL INTERCEPTOR] Email redirected to: #{interceptor_address}"
  end
end
