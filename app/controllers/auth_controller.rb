class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[signup login]
  include JsonWebToken

  def signup
    user = User.create!(user_params)
    render json: auth_response(user), status: :created
  end

  def login
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      render json: auth_response(user)
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def auth_response(user)
    {
      token: encode_token(user_id: user.id),
      user: { id: user.id, name: user.name, email: user.email }
    }
  end
end
