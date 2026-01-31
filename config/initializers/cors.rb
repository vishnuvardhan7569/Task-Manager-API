if Rails.env.development?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      # Allow Vite dev server hosts (common 5173/5174) during development
      origins "http://localhost:5173", "http://localhost:5174", %r{http://localhost:\d+}

      resource "*",
        headers: :any,
        methods: %i[get post patch put delete options],
        expose: %w[Authorization],
        max_age: 86_400
    end
  end
end
