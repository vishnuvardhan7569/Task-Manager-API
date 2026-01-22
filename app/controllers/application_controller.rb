class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def authorize_request
    token = request.headers["Authorization"]&.split&.last
    raise JWT::DecodeError, "Missing token" unless token

    payload = decode_token(token)
    @current_user = User.find(payload["user_id"])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def record_not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def record_invalid(e)
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
